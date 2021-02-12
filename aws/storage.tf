# The system disk is 7.7GB which is sufficient for the application and components, but we will need more space for storing everything that OpenCTI wants to consume. The instance type we're using only allows for AWS EBS (Elastic Block Store) for disks so that's what we're going to attach. The recommendation is a minimum of 32GB disk space.
resource "aws_ebs_volume" "opencti_ebs_volume" {
  availability_zone = "us-east-1a"
  size              = var.ebs_volume_size
}

# AWS recommends that EBS instances be named `/dev/sd[f-p]`: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html#available-ec2-device-names
resource "aws_volume_attachment" "attach_ebs" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.opencti_ebs_volume.id
  instance_id = aws_instance.opencti_instance.id
}

# S3 resources
resource "aws_s3_bucket" "opencti" {
  bucket = local.opencti_bucket_name
  acl    = "private"
}

data "aws_iam_policy_document" "opencti-s3" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${local.opencti_bucket_name}",
      "arn:aws:s3:::${local.opencti_bucket_name}/*",
    ]
  }
}

resource "aws_iam_policy" "opencti-s3" {
  name   = "opencti_s3"
  policy = data.aws_iam_policy_document.opencti-s3.json
}

resource "aws_iam_role_policy_attachment" "opencti-s3-attach" {
  role       = aws_iam_role.opencti.name
  policy_arn = aws_iam_policy.opencti-s3.arn
}

# OpenCTI installer script
resource "aws_s3_bucket_object" "opencti-install-script" {
  bucket = aws_s3_bucket.opencti.id
  key    = "opencti-installer.sh"
  source = "opencti_scripts/installer.sh"
}

# OpenCTI connectors script
resource "aws_s3_bucket_object" "opencti-connectors-script" {
  bucket = aws_s3_bucket.opencti.id
  key    = "opencti-connectors.sh"
  source = "opencti_scripts/connectors.sh"
}
