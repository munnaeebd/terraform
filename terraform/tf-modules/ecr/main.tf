resource "aws_ecr_repository" "ecr" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
        scan_on_push = true
  }
}
######################## ecr image scan #######################################
resource "aws_ecr_registry_scanning_configuration" "image_scanning" {
  scan_type = "BASIC"

  rule {
    scan_frequency = "SCAN_ON_PUSH" ### CONTINUOUS_SCAN ## if want CONTINUOUSly SCAN
    repository_filter {
      filter      = "*"
      filter_type = "WILDCARD"
    }
  }
 # rule {
 #   scan_frequency = "CONTINUOUS_SCAN"
 #   repository_filter {
 #     filter      = "example"
 #     filter_type = "WILDCARD"
 #   }
 # }
}