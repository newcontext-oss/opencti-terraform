# EC2 Instance
resource "aws_instance" "opencti" {
  ami           = local.ami_id
  instance_type = local.instance_type

  # Default VPC subnet for NC Sandbox
  subnet_id                   = local.subnet_id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.opencti-profile.name

  user_data = templatefile("../userdata/installation-wrapper-script.sh", {
    opencti_bucket_name            = local.opencti_bucket_name,
    opencti_install_email          = local.opencti_install_email,
    opencti_install_script_name    = local.opencti_install_script_name,
    opencti_connectors_script_name = local.opencti_connectors_script_name
  })

  vpc_security_group_ids = [aws_security_group.opencti.id]

  tags = {
    Name = "opencti"
  }
}
