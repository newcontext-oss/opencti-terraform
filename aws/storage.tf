# S3 bucket to store install and connectors scripts.
resource "aws_s3_bucket" "opencti_bucket" {
  bucket = var.storage_bucket
  acl    = "private"

  # Turn on bucket versioning. We'll be storing the Terraform state in S3 and versioning will help protect against human error.
  versioning {
    enabled = true
  }
}

# S3 IAM (I don't think any of these permissions are being used)
data "aws_iam_policy_document" "opencti_s3" {
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${var.storage_bucket}",
      "arn:aws:s3:::${var.storage_bucket}/*",
    ]
  }
}

resource "aws_iam_policy" "opencti_s3" {
  name   = "opencti_s3"
  policy = data.aws_iam_policy_document.opencti_s3.json
}

resource "aws_iam_role_policy_attachment" "opencti_s3_attach" {
  role       = aws_iam_role.opencti_role.name
  policy_arn = aws_iam_policy.opencti_s3.arn
}

# OpenCTI installer script
resource "aws_s3_bucket_object" "opencti-install-script" {
  bucket = aws_s3_bucket.opencti_bucket.id
  key    = "opencti-installer.sh"
  source = "../opencti_scripts/installer.sh"
}

# OpenCTI connectors script
resource "aws_s3_bucket_object" "opencti-connectors-script" {
  bucket = aws_s3_bucket.opencti_bucket.id
  key    = "opencti-connectors.sh"
  source = "../opencti_scripts/connectors.sh"
}
