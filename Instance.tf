provider "aws" {
	region="eu-west-1"
}

resource "aws_eip" "Git_EIP" {
  vpc = true

  instance                  = "${aws_instance.GitServer.id}"
  #associate_with_private_ip = "10.0.0.12"
  depends_on                = ["aws_internet_gateway.Git_IGW"]
}


resource "aws_instance" "GitServer" {
ami = "ami-0c143cb48fa7c1ec9"
instance_type = "t3.xlarge"
#iam_instance_profile = "${aws_iam_instance_profile.Shubham_profile.name}"
subnet_id = "${aws_subnet.GitSubnet.id}"
vpc_security_group_ids = ["${aws_security_group.Git_SecurityGroup.id}"]
#disable_api_termination = "true"
key_name = var.key_name

tags = {
Name = "GitServer"
}

}