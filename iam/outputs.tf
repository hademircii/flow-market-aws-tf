output "iam_instance_profile_id" {
  value = "${aws_iam_instance_profile.ecs_profile.id}"
}