# EC2 Instance
resource "aws_instance" "opencti_instance" {
  ami           = local.ami_id
  instance_type = var.instance_type

  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.opencti_profile.name
  root_block_device {
    volume_size = var.root_volume_size
  }
  subnet_id = var.subnet_id

  # The wrapper script is used by each of the providers and each variable has to be filled out in order to run. Unfortunately, this means that if you change something in one provider, you have to change it in each of the others. It's not ideal, but FYI.
  user_data = templatefile("../userdata/installation-wrapper-script.sh", {
    account_name           = "only for azure",
    cloud                  = "aws",
    connection_string      = "only for azure",
    connectors_script_name = local.opencti_connectors_script_name,
    install_script_name    = local.opencti_install_script_name,
    login_email            = var.login_email,
    storage_bucket         = var.storage_bucket
  })

  vpc_security_group_ids = [aws_security_group.opencti_sg.id]

  tags = {
    Name = "opencti"
  }
}
