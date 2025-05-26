// create service account and put key in file
module "networking" {
  source     = "./modules/networking"
  project_id = var.project_id
  region     = var.region
}

module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id
}

module "gke" {
  source                    = "./modules/gke"
  vpc_id                  = module.networking.vpc_id
  gke_service_account_email = module.iam.gke_service_account_email
  management_subnet_cidr    = module.networking.management_subnet_cidr
  restricted_subnet_name      = module.networking.restricted_subnet_name
  project_id = var.project_id
}

module "compute" {
  source = "./modules/compute"
  vpc_name = module.networking.vpc_name
  management_subnet_name = module.networking.management_subnet_name
  project_id = var.project_id
}

module "artifact" {
    source     = "./modules/artifact"  
}