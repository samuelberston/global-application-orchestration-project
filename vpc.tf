# goat-vpc
resource "aws_vpc" "terraform_orchestration_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "goap-vpc"
  }
}

# Public subnets (2)
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.terraform_orchestration_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "goap-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.terraform_orchestration_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "goap-public-subnet-2"
  }
}

# Private subnets (2)

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.terraform_orchestration_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "goap-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.terraform_orchestration_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "goap-private-subnet-2"
  }
}

# IGW for public subnets

resource "aws_internet_gateway" "goap_igw" {
  vpc_id = aws_vpc.terraform_orchestration_vpc.id
  tags = {
    Name = "goap-igw"
  }
}

# Public route table

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.terraform_orchestration_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.goap_igw.id
  }
  tags = {
    Name = "goap-public-route-table"
  }
}

# Public route table associations with public subnets

resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.terraform_orchestration_vpc.id
  tags = {
    Name = "goap-private-route-table"
  }
}

# Private route table association with private subnets

resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

# NAT gateway for private subnets to reach internet
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "goap_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "goap-nat-gateway"
  }
}

# Update private route table with NAT Gateway route
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.goap_nat.id
}

