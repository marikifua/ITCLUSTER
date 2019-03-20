/*
  Database Servers
*/
resource "aws_security_group" "db_sg" {
    name = "itcluster-vpc_db"
    description = "Allow incoming database connections."

    ingress { # SQL Server
        from_port = 1433
        to_port = 1433
        protocol = "tcp"
        security_groups = ["${aws_security_group.web_sg.id}"]
    }
    ingress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = ["${aws_security_group.web_sg.id}"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.itcluster_vpc_cidr}"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["${var.itcluster_vpc_cidr}"]
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

    vpc_id = "${aws_vpc.itcluster_vpc.id}"

    tags {
        Name = "ITCLUSTER DBServer SG"
    }
}

resource "aws_instance" "db" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-east-2a"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
    subnet_id = "${aws_subnet.us-east-2a-private.id}"
    source_dest_check = false

    tags {
        Name = "ITCLUSTER DB Server"
    }
}

