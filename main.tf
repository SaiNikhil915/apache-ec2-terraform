# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" 
}

# 1. Create VPC
resource "aws_vpc" "sample_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "sample-vpc"
  }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.sample_vpc.id

  tags = {
    Name = "sample-gateway"
  }
}

# 3. Create Custom Route Table
resource "aws_route_table" "route_table_1" {
  vpc_id = aws_vpc.sample_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "sample-route"
  }
}

# 4. Create a Subnet
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.sample_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "sample-subnet"
  }
}

# 5. Associate Subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table_1.id
}

# 6. Create Security Group (Allow ports 22, 80, 443)
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow SSH, HTTP, and HTTPS traffic"
  vpc_id      = aws_vpc.sample_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-web"
  }
}

# 7. Create Network Interface
resource "aws_network_interface" "webserver_nic" {
  subnet_id       = aws_subnet.subnet_1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

# 8. Create Ubuntu EC2 Instance with Apache2
resource "aws_instance" "web_server" {
  ami               = "ami-084568db4383264d4"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "main-key"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.webserver_nic.id
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                echo "Your very first web server is running!" | sudo tee /var/www/html/index.html
                EOF

  tags = {
    Name = "my-web-server"
  }
}

# 9. Assign Elastic IP to EC2 Instance
resource "aws_eip" "eip_1" {
  domain   = "vpc"
  instance = aws_instance.web_server.id  # Associate directly with EC2 instance

  depends_on = [aws_instance.web_server] # Ensure instance is fully created first
}