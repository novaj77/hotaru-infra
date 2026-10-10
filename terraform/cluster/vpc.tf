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
