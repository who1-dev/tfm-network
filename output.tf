output "vpcs" {
  value = { for k, v in aws_vpc.this : k => { id = v.id, cidr_block = v.cidr_block } }
}

output "public_subnets" {
  value = { for k, v in aws_subnet.public : k => v.id }
}

output "private_subnets" {
  value = { for k, v in aws_subnet.private : k => v.id }
}

output "public_route_table" {
  value = { for k, v in aws_route_table.public : k => v.id }
}

output "private_route_table" {
  value = { for k, v in aws_route_table.private : k => v.id }
}