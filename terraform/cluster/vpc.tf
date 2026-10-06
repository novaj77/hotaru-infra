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
