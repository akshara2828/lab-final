provider "aws" {
  region = "us-west-1"
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  tags = {
    Environment = "Production"
  }
}


module "load_balancer" {
  source   = "./modules/load_balancer"
  vpc_id   = "vpc-0f28e470f5a750360"                         # Replace with actual VPC ID
  subnets  = ["subnet-00874a3ac4989626b", "subnet-046e8b1012352a2b8"] # Public subnets
  tags = {
    Environment = "Production"
  }
}

module "compute" {
  source = "./modules/compute"
  vpc_id = "vpc-0f28e470f5a750360" # Replace with your actual VPC ID
  subnets = ["subnet-00874a3ac4989626b", "subnet-046e8b1012352a2b8"] # Public subnets
  iam_instance_profile  = module.iam.ec2_instance_profile  # Pass the output from IAM module
  tags = {
    Environment = "Production"
  }
}

module "storage" {
  source = "./modules/storage"
  subnets = [
    "subnet-047d28c5107564747", # Private Subnet (us-west-1c)
    "subnet-04b7bc1d14e0d8313"  # Private Subnet (us-west-1a)
  ]
  db_password = "securepassword123"
  tags = {
    Environment = "Production"
  }
}


module "monitoring" {
  source = "./modules/monitoring"
}

module "iam" {
  source = "./modules/iam"
}

module "cloudfront" {
  source = "./modules/cloudfront"
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

