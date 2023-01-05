data "aws_route53_zone" "zone" {
  name = "bg.hashicorp-success.com"
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "daniela.${data.aws_route53_zone.zone.name}"
  type    = "A"
  ttl     = "300"
  records = [data.aws_instance.public-dns.public_ip]
}