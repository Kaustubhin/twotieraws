/*resource "aws_key_pair" "my_server_key" {
  key_name = "myserverkey"
  public_key = "${file("${var.key_pair_path}")}"
}*/

resource "aws_instance" "web_server" {
  ami = "ami-0e5311d6d20d31efa"
  instance_type = "t2.micro"
  subnet_id = "${var.pub_sub_1}"
  key_name = "myserverkey"
  vpc_security_group_ids = ["${var.webserver_sg}"]

  tags = {
    Name = "WebServer"
  }
}

resource "aws_instance" "db_server" {
  ami = "ami-0dc2d2411eb47f9b3"
  instance_type = "t2.micro"
  subnet_id = "${var.prv_sub_1}"
  key_name = "myserverkey"
  vpc_security_group_ids = "var.mssql_sg[0]"

  tags = {
    Name = "DBServer"
  }
}

#--------Load Balancer-----------
resource "aws_alb" "web_server_alb" {
  name = "webserveralb"
  internal = "false"
  security_groups = ["${var.lb_sg}"]
  subnets = ["${var.pub_sub_1}", "${var.pub_sub_2}"]

  tags = {
    Name = "web_server_alb"
  }
}

#----------Load Balancer Listner---------
resource "aws_alb_listener" "alb_http_listener" {
  load_balancer_arn = "${aws_alb.web_server_alb.arn}"
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.web_server_alb_tg.arn}"
    type = "forward"
  }
}
#---------LB Targate Group------------
resource "aws_alb_target_group" "web_server_alb_tg" {
  name = "web-server-lb-tg"
  port = "80"
  protocol = "HTTP"
  vpc_id  ="${var.vpc_id}"
}

resource "aws_alb_target_group_attachment" "web_server_alb_tg_attach" {
  target_group_arn = "${aws_alb_target_group.web_server_alb_tg.arn}"
  target_id = "${aws_instance.web_server.id}"
  port = "80"
}