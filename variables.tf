variable "project" {
  description = "project name"
  type = string
}
variable "environment" {
  description = "environment name"
  type        = string
}
variable "cluster_version" {
  description = "cluster version number"
  type = string
  default = "1.34"
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be created"
  type        = string
}
variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS control plane and node groups"
  type        = list(string)
}


variable "cluster_security_group_ids" {
  description = "List of additional security group IDs to attach to the EKS control plane. Module consumer is responsible for creating these."
  type        = list(string)
  # default     = []
}

variable "node_security_group_ids" {
  description = "List of security group IDs to attach to worker nodes via launch template. EKS cluster SG is always attached automatically."
  type        = list(string)
  # default     = []
}


variable "eks_managed_node_groups" {
  description = <<-EOT
    Map of managed node group configurations.
    Set create=false to disable a node group without removing it from config.
    Blue-Green upgrade: enable_blue=true, enable_green=true during upgrade,
    drain blue, then set enable_blue=false.
  EOT
  type = map(object({
    create                       = optional(bool, true)
    ami_type                     = optional(string, "AL2023_x86_64_STANDARD")
    kubernetes_version           = optional(string, "")
    instance_types               = optional(list(string), ["t3.medium"])
    capacity_type                = optional(string, "ON_DEMAND")
    disk_size                    = optional(number, 20)
    min_size                     = optional(number, 1)
    max_size                     = optional(number, 5)
    desired_size                 = optional(number, 2)
    labels                       = optional(map(string), {})
    taints = optional(map(object({
      key    = string
      value  = string
      effect = string
    })), {})
    iam_role_additional_policies = optional(map(string), {})
  }))
  default = {
    blue = {}
  }
}