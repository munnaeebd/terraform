resource "aws_s3_bucket" "mn-test-bucket" {
	bucket = "mn-bucket-20232023"
}
resource "aws_instance" "webserver" {
	ami = "ami-0753e0e42b20e96e3"
	instance_type = "t2.micro"
	key_name = "mn-key-pair"
	subnet_id = "subnet-09ab9c2d03d3b659d"
	vpc_security_group_ids = [ aws_security_group.terraform-ssh-access.id ]
}
resource "aws_security_group" "terraform-ssh-access" {
	name = "terraform-ssh-access"
	description = "Allow SSH access from the Internet"
	vpc_id = "vpc-0b4f416c15959de1b"
	ingress {
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
    }
	ingress {
	from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	}	
}
output "public_ip_address" {
	value = aws_instance.webserver.public_ip
}
