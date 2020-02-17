data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "base" {
  name = "flow_market_role_ecs_instance_role"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}


resource "aws_iam_role_policy_attachment" "complete-ecs" {
  role = "${aws_iam_role.base.id}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}


resource "aws_iam_role_policy_attachment" "ecs_cloudwatch_role" {
  role = "${aws_iam_role.base.id}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_instance_profile" "ecs_profile" {
  name = "flow_market_ecs_instance_profile"
  role = "${aws_iam_role.base.name}"
}


