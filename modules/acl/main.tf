resource "aws_wafv2_web_acl" "exo_web_acl" {
  name  = "mon_web_acl"
  description = "web ACL(Access Control List) to block access to Said (if you want to test you have to come to France)"
  scope = "REGIONAL"

  default_action {
    allow {}
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
  resource_arn = var.lb_arn
  web_acl_arn  = aws_wafv2_web_acl.exo_web_acl.arn
}