locals {
    region               = "${var.region}"
    pg_volume_name       = "${var.postgres_volume_name}"
    redis_volume_name    = "${var.redis_volume_name}"
    postgres_url         = "${var.pg_user}:${var.pg_password}@localhost:5432/${pg_db_name}?encoding=utf8"
    redis_url            = "redis://localhost:6379/0"

}

resource "aws_cloudwatch_log_group" "flow_market" {
    name = "flow_market"
}


data "template_file" "flow_market" {
  template = "${file("${path.module}/container_templates/flow_market.json")}"

  vars {
    image        = "${var.flow_market_image}"
    log_group    = "${aws_cloudwatch_log_group.name}"
    aws_region   = "${local.region}"
    database_url = "${local.postgres_url}"
    redis_url    = "${local.redis_url}"
    admin_name   = "${var.admin_name}"
    admin_email  = "${var.admin_email}"
    secret       = "${var.app_secret}"
  }
}

data "template_file" "flow_market_worker" {
  template = "${file("${path.module}/container_templates/flow_market_worker.json")}"

  vars {
    image        = "${var.flow_market_worker_image}"
    aws_region   = "${local.region.region}"
    log_group    = "${aws_cloudwatch_log_group.name}"
    database_url = "${local.postgres_url}"
    redis_url    = "${local.redis_url}"
  }
}

data "template_file" "flow_market_postgres" {
  template = "${file("${path.module}/container_templates/postgres.json")}"

  vars {
    aws_region     = "${local.region}"
    log_group      = "${aws_cloudwatch_log_group.name}"
    pg_user        = "${var.pg_user}"
    pg_password    = "${var.pg_password}"
    pg_db_name     = "${var.pg_db_name}"
    pg_volume_name = "${local.pg_volume_name}"
  }
}

data "template_file" "flow_market_redis" {
  template = "${file("${path.module}/container_templates/redis.json")}"

  vars {
    aws_region        = "${local.region}"
    log_group         = "${aws_cloudwatch_log_group.name}"
    redis_volume_name = "${local.redis_volume_name}"
  }
}


resource "aws_ecs_task_definition" "flow_market" {
    family                  = "flow-market"
    container_definitions   = <<EOF
    [
        "${data.template_file.flow_market.rendered}",
        "${data.template_file.flow_market_worker.rendered}",
        "${data.template_file.flow_market_postgres.rendered}",
        "${data.template_file.flow_market_redis.rendered}"
    ]
    EOF
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    volumes = <<EOF
    [
        {
            "name": "${local.pg_volume_name}"
        },
        {
            "name": "${local.redis_volume_name}"
        }
    ]
    EOF
}
