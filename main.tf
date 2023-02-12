variable "aws_access_key"  {}
variable "aws_secret_key"  {}
variable "aws_region"      {}

provider "aws" {
  region  = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-lambdaRole-waf"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "archive_file" "python_lambda_package" {
  type = "zip"
  source_file = "lambda_function.py"
  output_path = "nametest.zip"
}

resource "aws_lambda_function" "test_lambda_function" {
    function_name = "lambdaTest"
    
    filename      = "nametest.zip"
    source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
    role          = aws_iam_role.lambda_role.arn
    runtime       = "python3.9"
    handler       = "lambda_function.lambda_handler"
    timeout       = 10
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "lambdabucketforfuckssake"
  
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.mybucket.id
  acl    = "private"
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "lambda_role_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:PutObject*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda_waf_policy" {
  name = "lambda-waf-policy"
  policy = data.aws_iam_policy_document.lambda_role_policy_document.json
  role = aws_iam_role.lambda_role.id
}

resource "aws_lambda_function_url" "test_latest" {
  function_name      = aws_lambda_function.test_lambda_function.function_name
  authorization_type = "NONE"
}

output "something" {
  value = aws_lambda_function_url.test_latest.function_url
}