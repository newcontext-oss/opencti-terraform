# IAM initial config
resource "aws_iam_role" "opencti_role" {
  name               = "opencti_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "opencti_profile" {
  name = "opencti_profile"
  role = aws_iam_role.opencti_role.name
}

# AWS Systems Manager (SSM)
data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "opencti_ssm_attach" {
  role       = aws_iam_role.opencti_role.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

# S3
data "aws_iam_policy" "s3readonly" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "opencti_readonly_attach" {
  role       = aws_iam_role.opencti_role.name
  policy_arn = data.aws_iam_policy.s3readonly.arn
}
