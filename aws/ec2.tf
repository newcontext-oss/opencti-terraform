# EC2 Instance
resource "aws_instance" "opencti_instance" {
  ami           = local.ami_id
  instance_type = local.instance_type

  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.opencti_profile.name
  root_block_device {
    volume_size = var.root_volume_size
  }
  subnet_id = var.subnet_id

  user_data = templatefile("../userdata/installation-wrapper-script.sh", {
    login_email                    = var.login_email,
    opencti_bucket_name            = local.s3_bucket,
    opencti_dir                    = local.opencti_dir,
    opencti_install_script_name    = local.opencti_install_script_name,
    opencti_connectors_script_name = local.opencti_connectors_script_name
  })

  vpc_security_group_ids = [aws_security_group.opencti_sg.id]

  tags = {
    Name = "opencti"
  }
}
