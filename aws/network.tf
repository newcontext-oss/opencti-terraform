# This code creates a VPC and Subnet. The code applies just fine. But Systems Manager (SSM) is unusable. Says something isn't right. Been tracking it down for far too long and it's outside the scope of this change anyway so commenting and moving along. This VPC/Subnet issue is tracked in #9.
# resource "aws_vpc" "opencti_vpc" {
#   cidr_block = "10.1.0.0/16"

#   tags = {
#     Name = "OpenCTI VPC"
#   }
# }

# resource "aws_subnet" "opencti_subnet" {
#   vpc_id            = aws_vpc.opencti_vpc.id
#   cidr_block        = "10.1.10.0/24"
#   availability_zone = var.availability_zone

#   tags = {
#     Name = "OpenCTI subnet"
#   }
# }

# resource "aws_network_interface" "opencti_nic" {
#   subnet_id   = aws_subnet.opencti_subnet.id
#   # private_ips = ["10.1.10.100"]
#   security_groups = [ aws_security_group.opencti_sg.id ]

#   tags = {
#     Name = "primary_network_interface"
#   }
# }
