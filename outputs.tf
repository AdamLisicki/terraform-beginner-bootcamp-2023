output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value = {for k in keys(local.hostings) : k => module.terrahome_aws[k].bucket_name}
}

output "s3_website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = {for k in keys(local.hostings) : k => module.terrahome_aws[k].website_endpoint}
}

output "cloudfront_url" {
  description = "The CloudFront Distribution Domain Name"
  value = {for k in keys(local.hostings) : k => module.terrahome_aws[k].domain_name}
}