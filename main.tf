
# Create a VPC
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16" # You can adjust the CIDR block as needed
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create two public subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24" # Adjust CIDR as needed
  availability_zone       = "us-east-1a" # Change AZ if necessary
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.2.0/24" # Adjust CIDR as needed
  availability_zone       = "us-east-1b" # Change AZ if necessary
  map_public_ip_on_launch = true
}

# Create two private subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.3.0/24" # Adjust CIDR as needed
  availability_zone       = "us-east-1a" # Change AZ if necessary
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.4.0/24" # Adjust CIDR as needed
  availability_zone       = "us-east-1b" # Change AZ if necessary
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.this.id
}

# Create a security group allowing ports 80 and 22
resource "aws_security_group" "sg1" {
  name        = "allow-http-ssh"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 instance in the public subnet with the security group
resource "aws_instance" "i1" {
  ami           = "ami-053b0d53c279acc90" # Replace with your desired AMI ID
  instance_type = "t2.micro" # Adjust instance type as needed
  subnet_id     = aws_subnet.public_subnet_1.id
  security_groups = [aws_security_group.sg1.id]
  
}


resource "aws_instance" "i2" {
  ami           = "ami-053b0d53c279acc90" # Replace with your desired AMI ID
  instance_type = "t2.micro" # Adjust instance type as needed
  subnet_id     = aws_subnet.public_subnet_2.id
  security_groups = [aws_security_group.sg1.id]

}