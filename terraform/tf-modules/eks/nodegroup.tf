# node group of spot workers
resource "aws_eks_node_group" "spot_node_group" {
  # count           = var.env == "uat" ? 1 : 0
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.env}-${var.project}-eks-spot-nodegroup"
  node_role_arn   = var.worker_node_role_arn
  subnet_ids      = var.subnet-ids
  ami_type        = "BOTTLEROCKET_x86_64"
  capacity_type   = "SPOT"
  disk_size       = 100
  instance_types  = var.node_group_instance_types
  tags            = {
    Name = "${var.env}-${var.project}-eks-spot-worker"
  }

  scaling_config {
    desired_size = var.spot_desired_size
    max_size     = var.spot_max_size
    min_size     = var.spot_min_size
  }

  update_config {
    max_unavailable = 1
  }
}
# node group for on-demand production workers
resource "aws_eks_node_group" "ondemand_node_group" {
  count           = var.env == "prod" ? 1 : 0
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.env}-${var.project}-eks-odemand-nodegroup"
  node_role_arn   = var.worker_node_role_arn
  subnet_ids      = var.subnet-ids
  ami_type        = "BOTTLEROCKET_x86_64"
  capacity_type   = "ON_DEMAND"
  disk_size       = 100
  instance_types  = var.node_group_instance_types
  tags            = {
    Name = "${var.env}-${var.project}-eks-ondemand-worker"
  }

  scaling_config {
    desired_size = var.ondemand_desired_size
    max_size     = var.ondemand_max_size
    min_size     = var.ondemand_min_size
  }

  update_config {
    max_unavailable = 1
  }
}

# resource.aws_eks_node_group.spot_node_group.resources.autoscaling_groups.name
resource "aws_autoscaling_schedule" "spot_nodegroup_scale_up" {
  count                  = var.env == "prod" ? 0 : 1
  scheduled_action_name  = "${var.env}-${var.project}-spot_nodegroup_scale_up"
  min_size               = var.spot_min_size
  max_size               = var.spot_max_size
  desired_capacity       = var.spot_desired_size
  recurrence             = "0 3 * * SUN-THU"
  autoscaling_group_name = resource.aws_eks_node_group.spot_node_group.resources[0].autoscaling_groups[0].name
}
resource "aws_autoscaling_schedule" "spot_nodegroup_scale_down" {
  count                  = var.env == "prod" ? 0 : 1
  scheduled_action_name  = "${var.env}-${var.project}-spot_nodegroup_scale_down"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "0 14 * * *"
  autoscaling_group_name = resource.aws_eks_node_group.spot_node_group.resources[0].autoscaling_groups[0].name
}
resource "aws_autoscaling_schedule" "spot_nodegroup_scale_down_midnight" {
  count                  = var.env == "prod" ? 0 : 1
  scheduled_action_name  = "${var.env}-${var.project}-midnight_spot_nodegroup_scale_down"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "0 20 * * *"
  autoscaling_group_name = resource.aws_eks_node_group.spot_node_group.resources[0].autoscaling_groups[0].name
}