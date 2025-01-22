resource "aws_s3_bucket" "documents" {
  bucket = "qa-solution-documents"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.documents.id
}