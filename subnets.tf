/*
  Public Subnet
*/
resource "aws_subnet" "us-east-2a-public" {
    vpc_id = "${aws_vpc.itcluster_vpc.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-east-2a"

    tags {
        Name = "ITCLUSTER Public Subnet"
    }
}

resource "aws_route_table" "us-east-2a-public" {
    vpc_id = "${aws_vpc.itcluster_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.vpc_ig.id}"
    }

    tags {
        Name = "ITCLUSTER Public Subnet"
    }
}

resource "aws_route_table_association" "ua-east-2a-public" {
    subnet_id = "${aws_subnet.us-east-2a-public.id}"
    route_table_id = "${aws_route_table.us-east-2a-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "us-east-2a-private" {
    vpc_id = "${aws_vpc.itcluster_vpc.id}"

    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "us-east-2a"

    tags {
        Name = "Private Subnet"
    }
}

resource "aws_route_table" "us-east-2a-private" {
    vpc_id = "${aws_vpc.itcluster_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }

    tags {
        Name = "ITCLUSTER Private Subnet"
    }
}

resource "aws_route_table_association" "us-east-2a-private" {
    subnet_id = "${aws_subnet.us-east-2a-private.id}"
    route_table_id = "${aws_route_table.us-east-2a-private.id}"
}
