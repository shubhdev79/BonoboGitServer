resource "aws_vpc" "GitVPC" {
  cidr_block = "172.16.0.0/16"

    tags = {
    Name = "GitVPC"
  }
}
 

resource "aws_internet_gateway" "Git_IGW" {
  vpc_id = "${aws_vpc.GitVPC.id}"
 
  tags = {
    Name = "Git_IGW"
  }
}
 
resource "aws_subnet" "GitSubnet" {
  vpc_id            = "${aws_vpc.GitVPC.id}"
  availability_zone = "eu-west-1a"
  cidr_block        = "172.16.1.0/24"
  map_public_ip_on_launch = "true"

    tags = {
    Name = "GitSubnet"
  }
}

resource "aws_route_table" "Public_RT_Git"{
vpc_id = "${aws_vpc.GitVPC.id}"
route{
cidr_block = "0.0.0.0/0"
gateway_id = "${aws_internet_gateway.Git_IGW.id}"
}
tags = {
Name = "Public_RT_Git"
}
}
 
resource "aws_route_table_association" "PublicSubnet_Association_Git" {
  subnet_id      = "${aws_subnet.GitSubnet.id}"
  route_table_id = "${aws_route_table.Public_RT_Git.id}"
}

resource "aws_security_group" "Git_SecurityGroup" {
    name = "GitVPC"
    description = "Allow incoming connections from Internet and RDP"
    vpc_id = "${aws_vpc.GitVPC.id}"

    ingress { 
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${"0.0.0.0/0"}"]
    }

    ingress {
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        cidr_blocks = ["${"14.98.201.90/32"}"]
    }

    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

   tags = {
       
        Name= "GitVPCSecurityGroup"
    }
}