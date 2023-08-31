resource "aws_default_network_acl" "dev-acl" { # Special resource please read https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl
  default_network_acl_id = aws_vpc.dev-vpc.default_network_acl_id
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    to_port    = 0
    from_port  = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    to_port    = 0
    from_port  = 0
  }
  subnet_ids = [
    aws_subnet.dev-subnet1.id,
    aws_subnet.dev-subnet2.id
  ]
}
