module "apigee" {
  source     = "./apigee-control-plane-modules/module"
  project_id = var.project_id
  organization = {
    display_name     = var.organization_display_name
    description      = var.organization_description
    runtime_type     = var.runtime_type
    analytics_region = var.analytics_region
  }

  envgroups    = var.envgroups

  environments = var.environments
}
