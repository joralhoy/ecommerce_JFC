
module "s3_tf_state"{
source = "./s3_tf_state"
}

module "vpc" {
  source          = "./vpc"
  project_name    = "jfc-ecommerce"
  vpc_cidr_block  = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
}

module "cloudfront_s3" {
  source       = "./cloudfront"
  project_name = "jfc-ecommerce"
  default_ttl  = 86400
  max_ttl      = 31536000
}

module "alb" {
  source            = "./alb"
  project_name      = "jfc-ecommerce"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "eks" {
  source            = "./eks"
  project_name      = "jfc-ecommerce"
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids 
}

module "aurora" {
  source                = "./aurora"
  project_name          = "jfc-ecommerce"
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  allowed_cidr_blocks    = ["10.0.0.0/16"] 
  master_username       = "admin"
  master_password       = "cl$veaur0ra"
  database_name         = "jfc_db"
  availability_zones    = ["us-east-1a", "us-east-1b"]
  instance_class        = "db.r5.large"
  instance_count        = 2
}

