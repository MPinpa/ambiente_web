module "rede" {
  source = "./modules/network"
  project_name = var.project_name
  env_name = var.env_name
  vpc_cidr_block = var.vpc_cidr_block
  public_subnets = var.public_subnets_cidr
  private_subnets = var.private_subnets_cidr
}

module "app" {
  depends_on = [ module.rede ]
  count = var.apps != null ? length(var.apps) : 0 
  source = "./modules/app"
  project_name = var.project_name
  vpc_id = module.rede.vpc_id
  env_name = var.env_name
  app_name = var.apps[count.index].app_name
  app_id = count.index
  public_subnet_ids = module.rede.public_subnets_ids
  private_subnet_ids = module.rede.private_subnets_ids
  ingress_allow = var.apps[count.index].ingress_allow
}