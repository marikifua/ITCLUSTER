/***
  VPC
***/
resource "aws_vpc" "itcluster_vpc" {
    cidr_block = "${var.itcluster_vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "ITCLUSTER VPC"
    }
}

resource "aws_internet_gateway" "vpc_ig" {
    vpc_id = "${aws_vpc.itcluster_vpc.id}"
    tags {
        Name = "ITCLUSTER IG" 
    }
}

/***
  NAT Instance
***/
resource "aws_security_group" "nat_sg" {
    name = "nat-sg"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.itcluster_vpc_cidr}"]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.itcluster_vpc.id}"

    tags {
        Name = "ITCLUSTER NAT SG"
    }
}

resource "aws_instance" "nat" {
    ami = "ami-f70f3692" # amzn-ami-vpc-nat-hvm-2018.03.0.20180622-x86_64-ebs   
    availability_zone = "us-east-2a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.nat_sg.id}"]
    subnet_id = "${aws_subnet.us-east-2a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    

   # availability_zone = "eu-west-1a"
   # instance_type = "m1.small"
   # key_name = "${var.aws_key_name}"
   # vpc_security_group_ids = ["${aws_security_group.nat.id}"]
   # subnet_id = "${aws_subnet.eu-west-1a-public.id}"
   # associate_public_ip_address = true
   # source_dest_check = false

    tags {
        Name = "ITCLUSTER NAT"
    }
}

#resource "aws_eip" "nat" {
 #   instance = "${aws_instance.nat.id}"
 #   vpc = true
#}

