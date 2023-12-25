resource "aws_codecommit_repository" "terraform_iaac_repo" {
  repository_name = "terraform-iaac-repo"
  description     = "Terraform resources"
}

output "repository_clone_url_ssh" {
  value = aws_codecommit_repository.terraform_iaac_repo.clone_url_http
}

resource "aws_s3_bucket" "codepipeline_terrafrom_s3_bucket" {
  bucket = "codepipeline-terraform-s3-bucket-419801"
}

resource "aws_s3_bucket_acl" "codepipeline_terraform_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline_terrafrom_s3_bucket.id
  acl    = "private"
}

resource "aws_cloudwatch_log_group" "codebuild_terraform_pipeline" {
  name = "codebuild/terraform_pipeline"
}

resource "aws_iam_role" "codebuild_terraform_role" {
  name               = "codebuild-terrafrom-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_terraform_policy" {
  name   = "codebuild_terraform_policy"
  role   = aws_iam_role.codebuild_terraform_role.id
  policy = <<EOF
{
    "Statement": [
        {
            "Action": "*",
            "Resource": "*",
            "Effect": "Allow"
        }
    ],
    "Version": "2012-10-17"
  }
EOF
}

resource "aws_iam_role" "codepipeline_terraform_role" {
  name               = "codepipeline-terraform-service-role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "codepipeline.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
EOF
}

resource "aws_iam_role_policy" "codepipeline_terraform_policy" {
  name   = "codepipeline_terraform_policy"
  role   = aws_iam_role.codepipeline_terraform_role.id
  policy = <<EOF
{
  "Statement": [
      {
          "Action": "*",
          "Resource": "*",
          "Effect": "Allow"
      }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_codebuild_project" "terraform" {
  name          = "terraform_resources"
  description   = "Apply terrafrom resource"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_terraform_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    environment_variable {
      name  = "TF_COMMAND"
      value = "apply"
    }
    environment_variable {
      name  = "TF_VERSION"
      value = "1.6.3"
    }
    environment_variable {
      name  = "db_username"
      value = var.db_username
    }
    environment_variable {
      name  = "db_password"
      value = var.db_password
    }

  }
  logs_config {
    cloudwatch_logs {
      group_name  = "codepipeline"
      stream_name = "terraform"
    }
  }
  source {
    type                = "CODEPIPELINE"
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
  }
}

resource "aws_codepipeline" "terrafrom_codepipeline" {
  name     = "terrafrom-pipeline"
  role_arn = aws_iam_role.codepipeline_terraform_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_terrafrom_s3_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      configuration = {
        RepositoryName = aws_codecommit_repository.terraform_iaac_repo.repository_name
        BranchName     = "main"
      }
    }
  }
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      region           = var.region
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.terraform.name
      }
    }
  }
}