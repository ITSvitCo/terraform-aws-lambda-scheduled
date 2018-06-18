module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.5"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
  tags       = "${var.tags}"
  enabled    = "${var.enabled}"
}

resource "aws_iam_role" "lambda" {
  count = "${var.enabled == "true" ? 1 : 0}"
  name  = "${module.label.id}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda" {
  count = "${var.enabled == "true" ? 1 : 0}"
  name  = "${module.label.id}"
  role  = "${aws_iam_role.lambda.name}"

  policy = "${var.iam_policy_document}"
}

resource "aws_lambda_function" "lambda" {
  count            = "${var.enabled == "true" ? 1 : 0}"
  runtime          = "${var.runtime}"
  filename         = "${var.lambda_zipfile}"
  function_name    = "${module.label.id}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "${var.handler}"
  source_code_hash = "${var.source_code_hash}"
  timeout          = "${var.timeout}"
}

resource "aws_lambda_permission" "cloudwatch" {
  count         = "${var.enabled == "true" ? 1 : 0}"
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.lambda.arn}"
}

resource "aws_cloudwatch_event_rule" "lambda" {
  count               = "${var.enabled == "true" ? 1 : 0}"
  name                = "${module.label.id}"
  schedule_expression = "${var.schedule_expression}"
}

resource "aws_cloudwatch_event_target" "lambda" {
  count     = "${var.enabled == "true" ? 1 : 0}"
  target_id = "${module.label.id}"
  rule      = "${aws_cloudwatch_event_rule.lambda.name}"
  arn       = "${aws_lambda_function.lambda.arn}"
}
