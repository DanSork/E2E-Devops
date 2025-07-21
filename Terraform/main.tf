data "aws_vpc" "exam_vpc" {
  id = "vpc-044604d0bfb707142"
}

resource "aws_instance" "builder" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t3.medium"
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.builder_key.key_name
  vpc_security_group_ids = [aws_security_group.dan_sg.id]
  associate_public_ip_address = true

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "docker --version",
      "docker-compose --version"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/home/ubuntu/workarea/devopshift/E2E-Devops/Terraform/builder_key.pem")
      host        = self.public_ip
    }
  }

  tags = {
  Name  = "dan-builder"
  Owner = "Dan"
    }
}
# resource "aws_subnet" "dan_public_subnet" {
#   vpc_id            = data.aws_vpc.exam_vpc.id
#   cidr_block        = "172.31.10.0/24"
#   availability_zone = "us-east-1a"
#}

resource "aws_internet_gateway" "dan_igw" {
  vpc_id = data.aws_vpc.exam_vpc.id

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "dan-builder-igw"
  }
}

resource "aws_route_table" "dan_rt_public" {
  vpc_id = data.aws_vpc.exam_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-0e29668aaedea32d1"
  }
}

resource "aws_route_table_association" "dan_public_association" {
  subnet_id = var.subnet_id
  route_table_id = aws_route_table.dan_rt_public.id
}

resource "aws_security_group" "dan_sg" {
  name        = "dan-builder-sg"
  description = "SG group for exam"
  vpc_id      = data.aws_vpc.exam_vpc.id

  ingress {
    description = "SSH from student IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["35.164.17.236/32"]
  }

  ingress {
    description = "HTTP"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["35.164.17.236/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dan-builder-sg"
  }
}
