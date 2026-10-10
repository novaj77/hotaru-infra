data "aws_vpc" "hotaru" {
  tags = {
    Name = "hotaru"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.hotaru.id]
  }

  filter {
    name   = "tag:Name"
    values = ["hotaru-public-*"]
  }
}

resource "aws_vpc" "hotaru" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "hotaru"
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.hotaru.id
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = true

  tags = {
    Name                     = "hotaru-public-${each.key}"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_internet_gateway" "hotaru" {
  vpc_id = aws_vpc.hotaru.id

  tags = {
    Name = "hotaru"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.hotaru.id

  tags = {
    Name = "hotaru-public"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.hotaru.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
