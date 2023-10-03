module "eks-cluster" {
  source     = "../tf-modules/eks"
  env        = local.env
  project    = local.project
  subnet-ids = [module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1], module.vpc.private_subnet_ids[2]]
  tags                      = merge(tomap({ "Name" = join("-", [local.env, local.project, "eks-cluster"]) }), tomap({ "ResourceType" = "EKS-cluster-resource" }), local.common_tags)
  eks-version               = local.eks-version
  vpc_id                    = local.rnd-vpc-id
  vpc-cidr-block            = local.vpc-cidr-block
  worker_node_role_arn      = module.eks-iam.aws_iam_role_arn
  ondemand_desired_size     = local.eks_ondemand_desired_size
  ondemand_max_size         = local.eks_ondemand_max_size
  ondemand_min_size         = local.eks_ondemand_min_size
  spot_desired_size         = local.eks_spot_desired_size
  spot_max_size             = local.eks_spot_max_size
  spot_min_size             = local.eks_spot_min_size
  node_group_instance_types = local.node_group_instance_types
}

# locals {
#   config_map_aws_auth = <<CONFIGMAPAWSAUTH
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: aws-auth
#   namespace: kube-system
# data:
#   mapRoles: |
#     - rolearn: ${module.eks-iam.aws_iam_role_arn}
#       username: system:node:{{EC2PrivateDNSName}}
#       groups:
#         - system:bootstrappers
#         - system:nodes
# CONFIGMAPAWSAUTH

#   kubeconfig = <<KUBECONFIG
# apiVersion: v1
# clusters:
# - cluster:
#     server: ${module.eks-cluster.eks_endpoint}
#     certificate-authority-data: ${module.eks-cluster.eks_certificate_authority.0.data}
#   name: kubernetes
# contexts:
# - context:
#     cluster: kubernetes
#     user: aws
#   name: aws
# current-context: aws
# kind: Config
# preferences: {}
# users:
# - name: aws
#   user:
#     exec:
#       apiVersion: client.authentication.k8s.io/v1alpha1
#       command: aws-iam-authenticator
#       args:
#         - "token"
#         - "-i"
#         - "${module.eks-cluster.cluster_name}"
# KUBECONFIG

# }

# resource "null_resource" "kubeconfig" {
#   provisioner "local-exec" {
#     command = <<BASH
# FILE=$HOME/.kube/config
# if test -f "$FILE"; then
#     echo "kubeconfig is ok"
# else
#     mkdir $HOME/.kube/
#     echo "${local.kubeconfig}" > $HOME/.kube/config
# fi
# BASH
#   }
# }

