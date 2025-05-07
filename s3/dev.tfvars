aws_profile = "default"
aws_region  = "ap-southeast-1"
bucket_name = "cmrs-frontend-hosting"
cloudfront_cdn_aliases = ["cmrsapp.site","www.cmrsapp.site"]
cloudfront_cert_arn            = "arn:aws:acm:us-east-1:585008058878:certificate/a0a8cd5f-8c07-4fcb-9090-3ad287711997"
cloudfront_min_protocol       = "TLSv1.2_2021"
cloudfront_ssl_supports        = "sni-only" 

cache_policy_id            = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
origin_request_policy_id   = "23d9fb60-ce13-4b6d-95f2-089e227b8c09"
response_headers_policy_id = "0bbea086-5bee-4a1a-8125-9521dbfdcfe2"