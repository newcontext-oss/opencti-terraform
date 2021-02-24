# Security group
resource "aws_security_group" "opencti_sg" {
  name   = "opencti_sg"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow access to application on port 4000"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips_application
  }

  egress {
    description = "Application can send outbound traffic to these IPs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "opencti security group"
  }
}
