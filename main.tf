# VPC Creation
resource "aws_vpc" "this" {
  for_each   = var.vpcs
  cidr_block = each.value.cidr_block
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-${each.value.name}"
  })
}

# IGW Creation
resource "aws_internet_gateway" "this" {
  for_each = var.igws
  vpc_id   = aws_vpc.this[each.value.vpc_key].id
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-${each.value.name}"
  })
  depends_on = [aws_vpc.this]
}

# PUBLIC - RT 
resource "aws_route_table" "public" {
  for_each = var.public_route_table
  vpc_id   = aws_vpc.this[each.value.vpc_key].id
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-${each.value.name}"
  })
  depends_on = [aws_vpc.this]
}

# PUBLIC SUBNET Creation
resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.this[each.value.vpc_key].id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-${each.value.name}"
  })
  depends_on = [aws_vpc.this]
}

# PRIVATE - RT 
resource "aws_route_table" "private" {
  for_each = var.private_route_table
  vpc_id   = aws_vpc.this[each.value.vpc_key].id
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-${each.value.name}"
  })
  depends_on = [aws_vpc.this]
}

# PRIVATE SUBNET Creation
resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.this[each.value.vpc_key].id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-${each.value.name}"
  })
  depends_on = [aws_vpc.this]
}

# PUBLIC - RT Association
resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  route_table_id = aws_route_table.public[each.value.rt_key].id
  subnet_id      = aws_subnet.public[each.key].id
  depends_on     = [aws_route_table.public]
}

# PRIVATE - RT Association
resource "aws_route_table_association" "private" {
  for_each       = var.private_subnets
  route_table_id = aws_route_table.private[each.value.rt_key].id
  subnet_id      = aws_subnet.private[each.key].id
  depends_on     = [aws_route_table.private]
}

# EIP Creation
resource "aws_eip" "this" {
  for_each = var.eips
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-${each.value.name}"
  })
}

# NAT GATEWAY Creation
resource "aws_nat_gateway" "this" {
  for_each      = var.natgws
  allocation_id = aws_eip.this[each.value.eip_key].id
  subnet_id     = aws_subnet.public[each.value.pub_sub_key].id
  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-${each.value.name}"
  })
  depends_on = [aws_internet_gateway.this, aws_subnet.public]
}

# Create Route for Internet Access (PUBLIC Subnet) using IGW
resource "aws_route" "public_internet_access" {
  for_each               = var.igws
  route_table_id         = aws_route_table.public[each.value.rt_key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[each.key].id
  depends_on             = [aws_internet_gateway.this]
}

# Create Route for Internet Access (PRIVATE Subnet) using NATGW
resource "aws_route" "private_internet_access" {
  for_each               = var.natgws
  route_table_id         = aws_route_table.private[each.value.rt_key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
  depends_on             = [aws_nat_gateway.this]
}


