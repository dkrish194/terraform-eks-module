
# eks control plane Related iam resources
data "aws_iam_policy_document" "eks_controlplane" {
  statement {
    effect = "Allow"
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = ["eks.amazonaws.com"]        // trust policy for eks control plane
    }
  }
}



# eks manage node group related
data "aws_iam_policy_document" "eks_node" {
  statement {
    effect = "Allow"
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]        // trust policy for eks control plane
    }
  }
}