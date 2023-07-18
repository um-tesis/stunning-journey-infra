resource "aws_s3_bucket" "libera_s3_bucket" {
  bucket = "libera-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "libera_ownership_controls" {
  bucket = aws_s3_bucket.libera_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "libera_access_block" {
  bucket = aws_s3_bucket.libera_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "libera_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.libera_ownership_controls,
    aws_s3_bucket_public_access_block.libera_access_block,
  ]

  bucket = aws_s3_bucket.libera_s3_bucket.id
  acl    = "public-read"  # public-read -> Owner gets FULL_CONTROL. The AllUsers group gets READ access.
}
