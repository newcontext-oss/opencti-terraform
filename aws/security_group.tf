# Security group
resource "aws_security_group" "opencti" {
  name   = "opencti"
  vpc_id = local.vpc_id

  ingress {
    description = "Allow access from these IPs"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/32"] # change (can be comma delimited)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "opencti"
  }
}
