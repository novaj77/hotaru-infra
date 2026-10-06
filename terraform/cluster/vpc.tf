resource "aws_vpc" "hotaru" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "hotaru"
  }
}
