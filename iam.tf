resource "aws_iam_role" "cluster" {
  name = "${var.project}-${var.environment}-eks-controlplane"
  assume_role_policy = data.aws_iam_policy_document.eks_controlplane
  tags = merge(local.common_tags,{
    name = "${var.project}-${var.environment}-eks-controlplane"
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  role = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# for eks managed node group
# Need to Attach 3 permissions for node group

resource "aws_iam_role" "node" {
  name = "${var.project}-${var.environment}-eks-node"
  assume_role_policy = data.aws_iam_policy_document.eks_node
  tags = merge(local.common_tags,{
    name = "${var.project}-${var.environment}-eks-node"
  })
}
# permission 1
resource "aws_iam_role_policy_attachment" "node_worker_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}
# permission 2
resource "aws_iam_role_policy_attachment" "node_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}
# permission 3
resource "aws_iam_role_policy_attachment" "node_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

# Additional policies passed via eks_managed_node_groups[*].iam_role_additional_policies
# Deduplicated across all node groups — attached to the shared node role
resource "aws_iam_role_policy_attachment" "node_additional" {
  for_each   = local.node_additional_policies
  policy_arn = each.value
  role       = aws_iam_role.node.name
}