#---------VPC------------
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16" 
    enable_dns_hostnames = true

    tags = {
        Name = "Demo_VPC"
    }
}
output "out_vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
output "out_vpc_cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}

#---------------IGW------------------

resource "aws_internet_gateway" "igw" {
  vpc_id ="${aws_vpc.vpc.id}"
  
  tags = {
    Name = "Demo_VPC_IGW"
}
}

#----------Public-Subnet---------------------
resource "aws_subnet" "pub_sub_1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
      Name = "Demo_Pub_sub_1"
  }
}
output "out_pub_sub1_id" {
  value = "${aws_subnet.pub_sub_1.id}"
}

resource "aws_subnet" "pub_sub_2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
      Name = "Demo_Pub_sub_2"
  }
}
output "out_pub_sub2_id" {
  value = "${aws_subnet.pub_sub_2.id}"
}
#-----------Private-Subnet---------------------------

resource "aws_subnet" "prv_sub_1" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = {
      Name = "Demo_Prv_sub_1"
  }
}
output "out_prv_sub1_id" {
  value = "${aws_subnet.prv_sub_1.id}"
}

resource "aws_subnet" "prv_sub_2" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = false   

  tags = {
      Name = "Demo_Prv_sub_2"
  }
}
output "out_prv_sub2_id" {
  value = "${aws_subnet.prv_sub_2.id}"
}

#-------------Public RouteTable------------
resource "aws_route_table" "pub_rt" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}" 
    }
    tags = {
        Name = "Public_Rt"
    }

}
#----------Public-Subnet-RouteTable- Association----------
resource "aws_route_table_association" "pub_sub_rt_1" {
  subnet_id = "${aws_subnet.pub_sub_1.id}"
  route_table_id = "${aws_route_table.pub_rt.id}"
}

resource "aws_route_table_association" "pub_sub_rt_2" {
  subnet_id = "${aws_subnet.pub_sub_2.id}"
  route_table_id = "${aws_route_table.pub_rt.id}"
}