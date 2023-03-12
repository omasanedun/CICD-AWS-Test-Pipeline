resource "aws_iam_role" "tf-codepipeline-omi-role" {
    name = "tf-codepipeline-omi-role"
    assume_role_policy = jsonencode({
        
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
  
}

data "aws_iam_policy_document" "tf-cicd-pipeline-policies-omi" {
    statement {
      sid = ""
      actions = ["codestar-connections:UseConnection"]
      resources = ["*"]
      effect = "Allow"
    
    }
    statement {
      sid = ""
      actions = ["cloudwatch:*", "s3:*", "codebuild:*"]
      resources = ["*"]
      effect = "Allow"
    }
}

resource "aws_iam_policy" "tf-cicd-pipeline-policy-omi" {
    name = "tf-cicd-pipeline-policy-omi"
    path = "/"
    description = "Pipeline policy"
    policy = data.aws_iam_policy_document.tf-cicd-pipeline-policies-omi.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-attachment" {
    role = aws_iam_role.tf-codepipeline-omi-role.id
    policy_arn = aws_iam_policy.tf-cicd-pipeline-policy-omi.arn
  
}

resource "aws_iam_role" "tf-codebuild-role" {
  name = "tf-codebuild-role"

  assume_role_policy = jsonencode ({
    
  Version = "2012-10-17",
  Statement = [
    {
      Action = "sts:AssumeRole",
      Principal = {
        Service = "codebuild.amazonaws.com"
      },
      Effect = "Allow",
      Sid = ""
    }
  ]
})

}

data "aws_iam_policy_document" "tf-cicd-build-policies" {
    statement{
        sid = ""
        actions = ["logs:*", "s3:*", "codebuild:*", "secretsmanager:*","iam:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "tf-cicd-build-policy" {
    name = "tf-cicd-build-policy"
    path = "/"
    description = "Codebuild policy"
    policy = data.aws_iam_policy_document.tf-cicd-build-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment1" {
    role        = aws_iam_role.tf-codebuild-role.id
    policy_arn  = aws_iam_policy.tf-cicd-build-policy.arn
   
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment2" {
    role        = aws_iam_role.tf-codebuild-role.id
    policy_arn  = "arn:aws:iam::aws:policy/PowerUserAccess"
    
}