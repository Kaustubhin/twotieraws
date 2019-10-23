provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source = "./modules/vpc"

  aws_region = "${var.aws_region}"
}

module "security-groups" {
  source = "./modules/security-groups"

  vpc_id = "${module.vpc.out_vpc_id}"
  aws_region = "${var.aws_region}"
  vpc_cidr_block = "${module.vpc.out_vpc_cidr}"
}

module "instance" {
  source = "./modules/instance"

  vpc_id = "${module.vpc.out_vpc_id}"
  pub_sub_1 = "${module.vpc.out_pub_sub1_id}"
  prv_sub_1 = "${module.vpc.out_prv_sub1_id}"
  webserver_sg = "${module.security-groups.out_web_server_sg_id}"
  mssql_sg= "${module.security-groups.out_mssql_sg_id}"
  lb_sg = "${module.security-groups.out_elb_sg_id}"
  pub_sub_2 = "${module.vpc.out_pub_sub2_id}"
  key_pair_path = "${var.key_pair_path}"
  ADMIN_USER ="${var.ADMIN_USER}"
  ADMIN_PASSWORD = "${var.ADMIN_PASSWORD}"
}