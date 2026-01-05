output "alb_dns_name" {
  value = module.compute.alb_dns_name
}

output "s3_bucket" {
  value = module.storage.bucket_name
}
