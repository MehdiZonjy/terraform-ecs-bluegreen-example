data "aws_iam_policy_document" "code_deploy_assume_policy" {
  statement {
    principals {
      identifiers = ["codedeploy.amazonaws.com"]
      type = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "AWSCodeDeployRoleForECS" {
  arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role" "ecsCodeDeployRole" {
  name = "ecsCoideDeployRole"
  tags = var.tags
  assume_role_policy = data.aws_iam_policy_document.code_deploy_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRoleForECS" {
  policy_arn = data.aws_iam_policy.AWSCodeDeployRoleForECS.arn
  role = aws_iam_role.ecsCodeDeployRole.name
}