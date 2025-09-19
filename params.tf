resource "aws_ssm_parameter" "satellite_api_key" {
  name  = "/satellite-spotter/api-key"
  type  = "SecureString"
  value = "placeholder"

  lifecycle {
    ignore_changes = [value]
  }
}
