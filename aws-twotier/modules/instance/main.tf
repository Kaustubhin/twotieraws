
resource "aws_instance" "web_server" {
  ami                    = "ami-0e5311d6d20d31efa"
  instance_type          = "t2.micro"
  subnet_id              = "${var.pub_sub_1}"
  key_name               = "myserverkey"
  vpc_security_group_ids = ["${var.webserver_sg}"]
  user_data              = <<EOF
<powershell>
net user ${var.ADMIN_USER} ‘${var.ADMIN_PASSWORD}’ /add /y
net localgroup administrators ${var.ADMIN_USER} /add

winrm quickconfig -q
winrm set winrm/config/winrs ‘@{MaxMemoryPerShellMB=”300″}’
winrm set winrm/config ‘@{MaxTimeoutms=”1800000″}’
winrm set winrm/config/service ‘@{AllowUnencrypted=”true”}’
winrm set winrm/config/service/auth ‘@{Basic=”true”}’

netsh advfirewall firewall add rule name=”WinRM 5985″ protocol=TCP dir=in localport=5985 action=allow
netsh advfirewall firewall add rule name=”WinRM 5986″ protocol=TCP dir=in localport=5986 action=allow

net stop winrm
sc.exe config winrm start=auto
net start winrm

Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer
Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpErrors
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment

Enable-WindowsOptionalFeature -online -FeatureName NetFx4Extended-ASPNET45
Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility45

Enable-WindowsOptionalFeature -Online -FeatureName IIS-HealthAndDiagnostics
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpLogging
Enable-WindowsOptionalFeature -Online -FeatureName IIS-LoggingLibraries
Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestMonitor
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpTracing
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Security
Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestFiltering
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Performance
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerManagementTools
Enable-WindowsOptionalFeature -Online -FeatureName IIS-IIS6ManagementCompatibility
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Metabase
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementConsole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-BasicAuthentication
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WindowsAuthentication
Enable-WindowsOptionalFeature -Online -FeatureName IIS-StaticContent
Enable-WindowsOptionalFeature -Online -FeatureName IIS-DefaultDocument
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebSockets
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationInit
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIExtensions
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIFilter
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionStatic
</powershell>
EOF

  tags = {
    Name = "WebServer"
  }
}

resource "aws_instance" "db_server" {
  ami                    = "ami-0e5311d6d20d31efa"
  instance_type          = "t2.micro"
  subnet_id              = "${var.prv_sub_1}"
  key_name               = "myserverkey"
  vpc_security_group_ids = ["${var.mssql_sg}"]
  user_data              = <<EOF
<powershell>
net user ${var.ADMIN_USER} ‘${var.ADMIN_PASSWORD}’ /add /y
net localgroup administrators ${var.ADMIN_USER} /add

winrm quickconfig -q
winrm set winrm/config/winrs ‘@{MaxMemoryPerShellMB=”300″}’
winrm set winrm/config ‘@{MaxTimeoutms=”1800000″}’
winrm set winrm/config/service ‘@{AllowUnencrypted=”true”}’
winrm set winrm/config/service/auth ‘@{Basic=”true”}’

netsh advfirewall firewall add rule name=”WinRM 5985″ protocol=TCP dir=in localport=5985 action=allow
netsh advfirewall firewall add rule name=”WinRM 5986″ protocol=TCP dir=in localport=5986 action=allow

net stop winrm
sc.exe config winrm start=auto
net start winrm
</powershell>
EOF

  tags = {
    Name = "DBServer"
  }
}

#--------Load Balancer-----------
resource "aws_alb" "web_server_alb" {
  name            = "webserveralb"
  internal        = "false"
  security_groups = ["${var.lb_sg}"]
  subnets         = ["${var.pub_sub_1}", "${var.pub_sub_2}"]

  tags = {
    Name = "web_server_alb"
  }
}

#----------Load Balancer Listner---------
resource "aws_alb_listener" "alb_http_listener" {
  load_balancer_arn = "${aws_alb.web_server_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.web_server_alb_tg.arn}"
    type             = "forward"
  }
}
#---------LB Targate Group------------
resource "aws_alb_target_group" "web_server_alb_tg" {
  name     = "web-server-lb-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb_target_group_attachment" "web_server_alb_tg_attach" {
  target_group_arn = "${aws_alb_target_group.web_server_alb_tg.arn}"
  target_id        = "${aws_instance.web_server.id}"
  port             = "80"
}
