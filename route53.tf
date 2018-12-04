// rust-embedded.org

resource "aws_route53_zone" "rust_embedded_org" {
  name = "rust-embedded.org."
}

resource "aws_route53_record" "rust_embedded_org_a" {
  zone_id = "${aws_route53_zone.rust_embedded_org.zone_id}"
  name = "rust-embedded.org."
  type = "A"
  ttl = "300"

  // Github apex domain IP addresses
  // https://help.github.com/articles/setting-up-an-apex-domain/
  records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153"
  ]
}

resource "aws_route53_record" "rust_embedded_org_www" {
  zone_id = "${aws_route53_zone.rust_embedded_org.zone_id}"
  name = "www.rust-embedded.org."
  type = "CNAME"
  ttl = "300"
  records = [ "rust-embedded.org" ]
}

// MX records for teams.rust-embedded.org email
resource "aws_route53_record" "teams_rust_embedded_org_mx" {
  zone_id = "${aws_route53_zone.rust_embedded_org.zone_id}"
  name = "teams.rust-embedded.org."
  type = "MX"
  ttl = "300"
  records = [ "10 mxa.mailgun.org.", "10 mxb.mailgun.org." ]
}

// SPF record for teams.rust-embedded.org email
resource "aws_route53_record" "teams_rust_embedded_org_spf" {
  zone_id = "${aws_route53_zone.rust_embedded_org.zone_id}"
  name = "teams.rust-embedded.org."
  type = "TXT"
  ttl = "300"
  records = [ "v=spf1 include:mailgun.org ~all" ]
}

// DomainKey record for teams.rust-embedded.org email
resource "aws_route53_record" "teams_rust_embedded_org_domainkey" {
  zone_id = "${aws_route53_zone.rust_embedded_org.zone_id}"
  name = "mx._domainkey.teams.rust-embedded.org."
  type = "TXT"
  ttl = "300"
  records = [ "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCl4e0N3NmgGI0m5dhFYlHqRyfpbViTdidprT+BDGPzyimP+MG8tV3Wj7VG5umZDAIis51DiUXWcQJADCfVYz7fnb0sV1mFoX9bA1SsKhr11V2DPK9a4IZ7g9JD8kjlY8bpThLBk9RP3d13aS1VKZ2Tm0WYSK1egB4NHVGgLJPJwwIDAQAB" ]
}

resource "aws_route53_record" "rust_embedded_org_docs" {
  zone_id = "${aws_route53_zone.rust_embedded_org.zone_id}"
  name = "docs.rust-embedded.org."
  type = "CNAME"
  ttl = "300"
  records = [ "rust-embedded.github.io" ]
}

// rust-embedded.com

resource "aws_route53_zone" "rust_embedded_com" {
  name = "rust-embedded.com."
}

resource "aws_s3_bucket" "rust_embedded_com_redirect" {
  bucket = "rust-embedded.com"
  acl = "public-read"
  website {
    redirect_all_requests_to = "rust-embedded.org"
  }
}

resource "aws_route53_record" "rust_embedded_com_a" {
  zone_id   = "${aws_route53_zone.rust_embedded_com.zone_id}"
  name      = "rust-embedded.com."
  type      = "A"
  alias {
    name    = "${aws_s3_bucket.rust_embedded_com_redirect.website_domain}"
    zone_id = "${aws_s3_bucket.rust_embedded_com_redirect.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "www_rust_embedded_com_redirect" {
  bucket = "www.rust-embedded.com"
  acl = "public-read"
  website {
    redirect_all_requests_to = "rust-embedded.org"
  }
}

resource "aws_route53_record" "rust_embedded_com_www" {
  zone_id   = "${aws_route53_zone.rust_embedded_com.zone_id}"
  name      = "www.rust-embedded.com."
  type      = "A"
  alias {
    name    = "${aws_s3_bucket.www_rust_embedded_com_redirect.website_domain}"
    zone_id = "${aws_s3_bucket.www_rust_embedded_com_redirect.hosted_zone_id}"
    evaluate_target_health = false
  }
}

// areweembeddedyet.com

resource "aws_route53_zone" "areweembeddedyet_com" {
  name = "areweembeddedyet.com."
}

resource "aws_s3_bucket" "areweembeddedyet_com_redirect" {
  bucket = "areweembeddedyet.com"
  acl = "public-read"
  website {
    redirect_all_requests_to = "rust-embedded.org"
  }
}

resource "aws_route53_record" "areweembeddedyet_com_a" {
  zone_id = "${aws_route53_zone.areweembeddedyet_com.zone_id}"
  name = "areweembeddedyet.com."
  type = "A"
  alias {
    name    = "${aws_s3_bucket.areweembeddedyet_com_redirect.website_domain}"
    zone_id = "${aws_s3_bucket.areweembeddedyet_com_redirect.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "www_areweembeddedyet_com_redirect" {
  bucket = "www.areweembeddedyet.com"
  acl = "public-read"
  website {
    redirect_all_requests_to = "rust-embedded.org"
  }
}

resource "aws_route53_record" "areweembeddedyet_com_www" {
  zone_id = "${aws_route53_zone.areweembeddedyet_com.zone_id}"
  name = "www.areweembeddedyet.com."
  type = "A"
  alias {
    name    = "${aws_s3_bucket.www_areweembeddedyet_com_redirect.website_domain}"
    zone_id = "${aws_s3_bucket.www_areweembeddedyet_com_redirect.hosted_zone_id}"
    evaluate_target_health = false
  }
}
