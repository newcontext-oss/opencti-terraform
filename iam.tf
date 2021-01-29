# IAM initial config
data "aws_iam_policy_document" "opencti-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "opencti" {
  name               = "opencti_role"
  assume_role_policy = data.aws_iam_policy_document.opencti-assume-role.json
}

resource "aws_iam_instance_profile" "opencti-profile" {
  name = "opencti_profile"
  role = aws_iam_role.opencti.name
}

# AWS Systems Manager (SSM)
data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "opencti-ssm-attach" {
  role       = aws_iam_role.opencti.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

data "aws_iam_policy" "s3readonly" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "opencti-readonly-attach" {
  role       = aws_iam_role.opencti.name
  policy_arn = data.aws_iam_policy.s3readonly.arn
}
