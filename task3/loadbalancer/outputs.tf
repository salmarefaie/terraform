output "alp_target_group_id" {
  value = aws_lb_target_group.target-group["alb-target-group"].id
}

output "nlp_target_group_id" {
  value = aws_lb_target_group.target-group["nlb-target-group"].id
}

output dns {
  value = aws_lb.nlb.dns_name
}
