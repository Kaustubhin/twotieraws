terraform {
  required_version = "=0.12.12"
  backend "s3" {
    bucket         = "s3-bucket-name-adodemo-tfstate"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    #dynamodb_table = "aws-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "${var.aws_region}"
  version = "~> 2.19.0"
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
}

module "ado_backend" {
  source = "./modules/ado_backend"

  name_of_s3_bucket            = "s3-bucket-name-adodemo-tfstate"
  #dynamo_db_table_name         = "aws-locks"
  iam_user_name                = "ADOIamUserDemo"
  #ado_iam_role_name            = "ADOIamRoleDemo"
  aws_iam_policy_permits_name  = "ADOIamPolicyPermitsDemo"
  aws_iam_policy_assume_name   = "ADOIamPolicyAssumeDemo"
  
}
