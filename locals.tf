locals {
  common_tags = {
    project = var.project
    environment = var.environment
    Managedby = Terraform

  }
    resource_name = "${var.project}-${var.environment}"
    # Only node groups with create = true
  active_node_groups = { for k, v in var.eks_managed_node_groups : k => v if v.create }


  # Flatten and deduplicate additional IAM policies across all node groups
  node_additional_policies = {
    for arn in distinct(flatten([
      for ng in values(var.eks_managed_node_groups) : values(ng.iam_role_additional_policies)
    ])) : arn => arn
  }










}





