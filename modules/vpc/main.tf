
resource "aws_security_group" "sg_lb" {
  name = "sg_lb"
  description = "Security group to access via port 80"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_alb" "load_balancer" {
  name               = "exo-terraform-lg"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_lb.id]
  subnets            = ["subnet-0b3d2c824f18a730b", "subnet-078925355d01c8d93"]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "app_target_group_1" {
  name = "app-target-group-1"
  port = 80
  protocol = "HTTP"
  vpc_id = "vpc-098efebbad38d2e35"
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.load_balancer.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_target_group_1.arn
  }
}

resource "aws_lb_target_group_attachment" "lb_attachment_1" {
  target_group_arn = aws_lb_target_group.app_target_group_1.arn
  target_id        = var.instance_id[0]
}

resource "aws_lb_target_group_attachment" "lb_attachment_2" {
  target_group_arn = aws_lb_target_group.app_target_group_1.arn
  target_id        = var.instance_id[1]
}

resource "aws_lb_listener_rule" "listener_rule_1" {
  listener_arn = aws_lb_listener.listener.arn
  priority = 40

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_target_group_1.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

#ACL Restriction by Country
resource "aws_wafv2_web_acl" "exo_web_acl" {
  name  = "mon_web_acl"
  description = "web ACL Access Control List to block access to Said if you want to test you have to come to France"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "blockSaidAlgeria"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "block-said-algeria"
    priority = 1

    action {
      block {}
    }

    statement {
      geo_match_statement {
        country_codes = ["DZ"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "blockSaidAlgeria"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_wafv2_web_acl_association" "lb_waf_association" {
  resource_arn = aws_alb.load_balancer.arn
  web_acl_arn  = aws_wafv2_web_acl.exo_web_acl.arn
}