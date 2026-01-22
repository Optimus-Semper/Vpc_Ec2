# Create EC2 Instance
resource "aws_instance" "Optimus" {
  instance_type = "t2.micro"
  ami = "ami-07ff62358b87c7116"
  key_name = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  subnet_id = aws_subnet.Public-Subnet1.id
  user_data = file("userdata.sh")
  tags = {
    Name = "Optimus2025"
  }
}
# Create EBS Volume
resource "aws_ebs_volume" "Vol20" {
  availability_zone = aws_instance.Optimus.availability_zone
  size = 20
  tags = {
    Name = "cloudvolume"
    Team = "cloud"
  }
}
# Attach Volume
resource "aws_volume_attachment" "name" {
  device_name = "/dev/sdb"
  volume_id = aws_ebs_volume.Vol20.id
  instance_id = aws_instance.Optimus.id
}
# Key pair
resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits = 2048
}
resource "aws_key_pair" "key" {
  key_name = "utc-key2025"
  public_key = tls_private_key.tls.public_key_openssh
}
resource "local_file" "key1" {
  filename = "utc-key2025.pem"
  content =  tls_private_key.tls.private_key_pem
}
# Security Group
resource "aws_security_group" "webserver-sg" {
  name = "webserver-sg"
  description = "22 for SSH, 80 for Apache and 8080 Open Everywhere"
vpc_id = aws_vpc.VPC2025.id
  ingress {
    description = "SSH from my IP"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["172.120.0.0/16"]
  }
  ingress {
    description = "HTTP for Apache"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    description = "8080 Open"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
tags = {
  Name = "webserver-sg"
}
}
