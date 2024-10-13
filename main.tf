# Cấu hình nhà cung cấp AWS
provider "aws" {
  region = "us-east-1" # Điều chỉnh nếu cần
}

# Tạo VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main_vpc"
  }
}

# Tạo Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main_igw"
  }
}

# Tạo các subnet công khai trong hai Availability Zones (AZ) khác nhau
resource "aws_subnet" "public_subnet_1" {
  vpc_id                = aws_vpc.main_vpc.id
  cidr_block            = "10.0.1.0/24"
  availability_zone     = "us-east-1a"  # Điều chỉnh AZ nếu cần
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                = aws_vpc.main_vpc.id
  cidr_block            = "10.0.2.0/24"
  availability_zone     = "us-east-1b"  # Điều chỉnh AZ nếu cần
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_2"
  }
}

# Tạo các subnet riêng tư trong hai AZ khác nhau
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"  # Điều chỉnh AZ nếu cần
  tags = {
    Name = "private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"  # Điều chỉnh AZ nếu cần
  tags = {
    Name = "private_subnet_2"
  }
}

# Tạo bảng định tuyến cho subnet công khai
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_rt"
  }
}

# Liên kết subnet công khai với bảng định tuyến công khai
resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Liên kết subnet riêng tư với bảng định tuyến riêng tư
resource "aws_route_table_association" "private_rt_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

# Security Group cho các instance, cho phép giao tiếp nội bộ và SSH từ bên ngoài
resource "aws_security_group" "allow_internal" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "allow_internal"

  # Cho phép tất cả giao thức trong VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Cho phép SSH từ bên ngoài
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Không khuyến khích, nên giới hạn IP cụ thể
  }

  tags = {
    Name = "allow_internal"
  }
}

# Thêm NAT Gateway cho các subnet riêng tư
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id  # Sử dụng subnet công khai

  tags = {
    Name = "nat_gateway"
  }
}

# Cập nhật bảng định tuyến cho các subnet riêng tư để sử dụng NAT Gateway
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "private_rt"
  }
}

# Tạo Bastion Host trong subnet công khai để quản lý các instance trong subnet riêng tư
resource "aws_instance" "bastion_host" {
  ami           = "ami-0c55b159cbfafe1f0"  # AMI của Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = "my-ec2-key-pair"  # Thay bằng tên cặp khóa của bạn

  vpc_security_group_ids = [aws_security_group.allow_internal.id]

  tags = {
    Name = "bastion_host"
  }
}
