variable "default_tags" {
  type        = map(any)
  description = "Default tags to be applied to all AWS resources"
}

variable "app_role" {
  type    = string
  default = "Network"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "namespace" {
  type = string
}

variable "env" {
  type = string
}


variable "remote_data_sources" {
  type = map(object({
    bucket = string
    key    = string
    region = string
  }))
  default = {
  }
}

variable "vpcs" {
  type = map(object({
    name       = string
    cidr_block = string
  }))
}

variable "igws" {
  type = map(object({
    vpc_key = string
    rt_key  = string
    name    = string
  }))
  default = {
  }
}

variable "public_route_table" {
  type = map(object({
    vpc_key = string
    name    = string
  }))
  default = {
  }
}

variable "public_subnets" {
  type = map(object({
    vpc_key           = string
    rt_key            = string
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
  default = {
  }
}

variable "private_route_table" {
  type = map(object({
    vpc_key = string
    name    = string
  }))
  default = {
  }
}

variable "private_subnets" {
  type = map(object({
    vpc_key           = string
    rt_key            = string
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
  default = {
  }
}

variable "eips" {
  type = map(object({
    name = string
  }))
  default = {
  }
}

variable "natgws" {
  type = map(object({
    eip_key     = string
    pub_sub_key = string
    rt_key      = string
    name        = string
  }))
  default = {
  }
}

#By default all subnets declared in var.public_subnets and var.private_subnets will be associated to the Route table
#In case of network isolation, use this fields to de associate it.
variable "filter_public_route_table_association" {
  description = "Public Subnet keys added to this will be deassociated with the Public Route Table"
  type        = list(string)
  default     = []
}
variable "filter_private_route_table_association" {
  description = "Private Subnet keys added to this will be deassociated with the Private Route Table"
  type        = list(string)
  default     = []
}