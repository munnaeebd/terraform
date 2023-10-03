output "eks_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}
output "eks_certificate_authority" {
  value = aws_eks_cluster.eks.certificate_authority
}
output "cluster_name" {
  value = aws_eks_cluster.eks.name
}
output "openID_connect_arn" {
  value = aws_iam_openid_connect_provider.example.arn
}
output "openID_connect_url" {
  value = aws_iam_openid_connect_provider.example.url
}
