#--------WebserverSG------------------
resource "aws_security_group" "webserver_sg" {
  vpc_id = "${var.vpc_id}"
  name = "Web_server_sg"
  description = "Web Server Seciruty Group"


  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.elb_sg.id}"]
  }

  egress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_server_sg"
  }

}
output "out_web_server_sg_id" {
  value = "${aws_security_group.webserver_sg.id}"
}

#----------AppserverSG------------------------------
resource "aws_security_group" "appserver_sg" {
  vpc_id = "${var.vpc_id}"
  name = "App_server_sg"
  description = "Application Server Security Group"

  ingress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    #----- Or ----
    #security_group = ""
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_server_sg"
  }
}

output "out_app_server_sg_id" {
  value = "${aws_security_group.appserver_sg.id}"
}

#--------LoadBalancerSG---------------------------
resource "aws_security_group" "elb_sg" {
  vpc_id = "${var.vpc_id}"
  name = "elb_sg"
  description = "ALB Security Group"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ELB_SG"
  }
}

output "out_elb_sg_id" {
  value = "${aws_security_group.elb_sg.id}"
}
#-----------DataBaseSG------------------------
resource "aws_security_group" "mssql_sg" {
  vpc_id = "${var.vpc_id}"
  name = "mssql_sg"
  description = "mssql DB Security Group"

  ingress {
    from_port = 1433
    to_port = 1433
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
    #-- Or --
    #security_group = ""
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mssql_SG"
  }
}

output "out_mssql_sg_id" {
  value = "${aws_security_group.mssql_sg}"
}
