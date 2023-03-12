resource "aws_s3_bucket" "codepipeline_artifacts_omasan" {
  bucket = "omasan-pipeline-artifacts"
  acl    = "private"
}