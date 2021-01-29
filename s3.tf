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

# OpenCTI installer script
resource "aws_iam_role_policy_attachment" "opencti-s3-attach" {
  role       = aws_iam_role.opencti.name
  policy_arn = aws_iam_policy.opencti-s3.arn
}

# OpenCTI Connectors script
resource "aws_s3_bucket_object" "opencti-install-script" {
  bucket = aws_s3_bucket.opencti.id
  key    = "opencti-installer.sh"
  source = "opencti_scripts/installer.sh"
}

resource "aws_s3_bucket_object" "opencti-connectors-script" {
  bucket = aws_s3_bucket.opencti.id
  key    = "opencti-connectors.sh"
  source = "opencti_scripts/connectors.sh"
}
