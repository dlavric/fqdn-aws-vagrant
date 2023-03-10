data "aws_route53_zone" "zone" {
  name = "bg.hashicorp-success.com"
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "nginxdani.${data.aws_route53_zone.zone.name}"
  type    = "A"
  ttl     = "300"
  records = "192.168.57.151"
}