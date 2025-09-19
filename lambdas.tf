data "archive_file" "satellite_spotter_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambdas/satellite-spotter"
  output_path = "${path.module}/satellite-spotter.zip"
}

resource "aws_lambda_function" "satellite_spotter" {
  filename         = data.archive_file.satellite_spotter_zip.output_path
  function_name    = "satellite-spotter"
  role             = aws_iam_role.satellite_spotter_role.arn
  handler          = "spotter.lambda_handler"
  runtime          = var.runtime
  timeout          = 30
  source_code_hash = data.archive_file.satellite_spotter_zip.output_base64sha256
}

resource "aws_iam_role" "satellite_spotter_role" {
  name = "satellite-spotter-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "satellite_spotter_policy" {
  name = "satellite-spotter-policy"
  role = aws_iam_role.satellite_spotter_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter"
        ]
        Resource = aws_ssm_parameter.satellite_api_key.arn
      }
    ]
  })
}
