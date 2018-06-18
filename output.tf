output "lambda_arn" {
  value = "${join("", aws_lambda_function.lambda.*.arn)}"
}

output "role_arn" {
  value = "${join("", aws_iam_role.lambda.*.arn)}"
}

output "role_name" {
  value = "${join("", aws_iam_role.lambda.*.name)}"
}
