resource "aws_codedeploy_deployment_group" "production" {
  deployment_group_name = "production-${aws_codedeploy_app.application.name}"

  app_name = "${aws_codedeploy_app.application.name}"
  service_role_arn = "${var.role_arn}"
  deployment_config_name = "${var.deployment_config_name}"

  ec2_tag_filter {
    key = "DeploymentGroup"
    value = "production-${aws_codedeploy_app.application.name}"
    type = "KEY_AND_VALUE"
  }
}

resource "aws_codedeploy_deployment_group" "testing" {
  deployment_group_name = "testing-${aws_codedeploy_app.application.name}"

  app_name = "${aws_codedeploy_app.application.name}"
  service_role_arn = "${var.role_arn}"
  deployment_config_name = "${var.deployment_config_name}"

  ec2_tag_filter {
    key = "DeploymentGroup"
    value = "testing-${aws_codedeploy_app.application.name}"
    type = "KEY_AND_VALUE"
  }
}

resource "aws_codedeploy_app" "application" {
  name = "${var.application_name}"
}
