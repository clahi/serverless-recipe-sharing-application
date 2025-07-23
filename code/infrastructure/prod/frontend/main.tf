terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }
  required_version = ">= 1.7"
}

provider "aws" {
  region = "us-east-1"
}

module "s3" {
  source      = "../../modules/Frontend/s3"
  environment = "prod"
  bucket_name = "severless-application-sdf34"
}

module "cloudFrontDistribution" {
  source                 = "../../modules/Frontend/cloudfront"
  aws_bucket_domain_name = module.s3.bucket_domain_name
}