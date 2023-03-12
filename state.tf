terraform{
    backend "s3" {
        bucket = "cicd-aws-test-pipeline"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}