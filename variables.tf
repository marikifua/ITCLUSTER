variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "aws_region" {
 description = "AWS region for the VPC"
 default = "us-east-2"
}
variable "amis" {
 description = "Base AMI to launch the instances"
 default = {
 us-east-2 = "ami-0653e888ec96eab9b" #ubuntu server 16.04 LTS
 }
}
variable "itcluster_vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "Subnet CIDRs for public subnets"
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "Subnet CIDRs for private subnets"
    default = "10.0.10.0/24"
}
variable "db_replication" {
    type = "list"
    description = "Setup master or slave replication"
    default = ["master", "slave"]
}
