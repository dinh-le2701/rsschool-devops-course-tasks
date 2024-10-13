output "vpc_id" {
  description = "ID của VPC được tạo"
  value       = aws_vpc.main_vpc.id
}

output "public_subnet_1_id" {
  description = "ID của public subnet 1"
  value       = aws_subnet.public_subnet_1.id
}

output "nat_gateway_ip" {
  description = "Địa chỉ IP của NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}

output "bastion_public_ip" {
  description = "Địa chỉ IP công khai của Bastion Host"
  value       = aws_instance.bastion_host.public_ip
}
