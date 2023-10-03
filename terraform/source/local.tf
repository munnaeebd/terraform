locals {
  env         = terraform.workspace
  owner       = "Technology"
  cost-center = "devops"
  project     = "rnd"
  version     = "v0.0.1"
  account-id  = "12345678"
  region      = "ap-southeast-1"
  common_tags = {
    Environment = local.env
    Version     = local.version
    Owner       = local.owner
    Cost-Center = local.cost-center
    Project     = local.project
  }


  vpc_cidr_blocks = {
    uat  = "10.10.10.0/20"
    sb   = ""
    lt   = ""
    prod = "10.10.20.0/20"
  }
  vpc-cidr-block = lookup(local.vpc_cidr_blocks, local.env)

  tf_vpc-domain-name = {
    uat  = "test.example.com"
    sb   = ""
    lt   = ""
    prod = ""
  }
  vpc-domain-name = local.tf_vpc-domain-name[local.env]
    tf_project-domain-name = {
    uat  = "example.com"
    sb   = ""
    lt   = ""
    prod = ""
  }
  project-domain-name = local.tf_project-domain-name[local.env]

  rnd_vpc_ids = {
    uat  = "vpc-xxxxxxxxxxx"
    sb   = ""
    lt   = ""
    prod = ""
  }
  rnd-vpc-id = local.rnd_vpc_ids[local.env]

  public_subnet_block_1a = {
    uat  = "subnet-xxxxxxxxxxxxx"
    sb   = "subnet-"
    lt   = "subnet-"
    prod = "subnet-"
  }
  public-subnet-block-1a = local.public_subnet_block_1a[local.env]
  public_subnet_block_1b = {
    uat  = "subnet-xxxxxxxxxx"
    sb   = "subnet-"
    lt   = "subnet-"
    prod = "subnet-"
  }
  public-subnet-block-1b = local.public_subnet_block_1b[local.env]
  public_subnet_block_1c = {
    uat  = "subnet-xxxxxxxxxxx"
    sb   = "subnet-"
    lt   = "subnet-"
    prod = "subnet-"
  }
  public-subnet-block-1c = local.public_subnet_block_1c[local.env]
  private_subnet_block_1a = {
    uat  = "subnet-xxxxxxxxxx"
    sb   = "subnet-"
    lt   = "subnet-"
    prod = "subnet-"
  }
  private-subnet-block-1a = local.private_subnet_block_1a[local.env]
  private_subnet_block_1b = {
    uat  = "subnet-xxxxxxxx"
    sb   = "subnet-"
    lt   = "subnet-"
    prod = "subnet-"
  }
  private-subnet-block-1b = local.private_subnet_block_1b[local.env]
  private_subnet_block_1c = {
    uat  = "subnet-xxxxxxxxxx"
    sb   = "subnet-"
    lt   = "subnet-"
    prod = "subnet-"
  }
  private-subnet-block-1c = local.private_subnet_block_1c[local.env]
  tf_eks-version = {
    uat  = "1.27"
    sb   = "1.27"
    lt   = "1.27"
    prod = "1.27"
  }
  eks-version = local.tf_eks-version[local.env]
  
  public_subnets_dict = {
    prod  = {
      "10.10.20.0/24" = {
        hosted_zone = "ap-southeast-1a"
        tags = merge({
          Name         = join("-", [local.env, local.project, "public", "ap-southeast-1a"])
          ResourceType = "SUBNET"
        }, local.common_tags)
      }
      "10.10.10.0/24" = {
        hosted_zone = "ap-southeast-1b"
        tags = merge({
          Name         = join("-", [local.env, local.project, "public", "ap-southeast-1b"])
          ResourceType = "SUBNET"
        }, local.common_tags)
      }
      "10.10.10.0/24" = {
        hosted_zone = "ap-southeast-1c"
        tags = merge({
          Name         = join("-", [local.env, local.project, "public", "ap-southeast-1c"])
          ResourceType = "SUBNET"
        }, local.common_tags)
      }
    }
    sb   = {}
    lt   = {}
    uat = {
      "10.10.10.0/24" = {
        hosted_zone = "ap-southeast-1a"
        tags = merge({
          Name         = join("-", [local.env, local.project, "public", "ap-southeast-1a"])
          ResourceType = "SUBNET"
        }, local.common_tags)
      }
      "10.10.11.0/24" = {
        hosted_zone = "ap-southeast-1b"
        tags = merge({
          Name         = join("-", [local.env, local.project, "public", "ap-southeast-1b"])
          ResourceType = "SUBNET"
        }, local.common_tags)
      }
      "10.10.12.0/24" = {
        hosted_zone = "ap-southeast-1c"
        tags = merge({
          Name         = join("-", [local.env, local.project, "public", "ap-southeast-1c"])
          ResourceType = "SUBNET"
        }, local.common_tags)
      }
    }
  }
  public-subnets = lookup(local.public_subnets_dict, local.env)

  private_subnets_dict = {
    uat  = {
      "10.10.20.6.0/24" = {
        hosted_zone = "ap-southeast-1a"
        tags = merge({
          Name         = join("-", [local.env, local.project, "private", "ap-southeast-1a"])
          ResourceType = "SUBNET"
        }, local.common_tags)
      }
      "10.10.20.7.0/24" = {
        hosted_zone = "ap-southeast-1b"
        tags = merge({
          Name         = join("-", [local.env, local.project, "private", "ap-southeast-1b"])
          ResourceType = "SUBNET"
        }, local.common_tags)
      }
      "10.10.20.8.0/24" = {
        hosted_zone = "ap-southeast-1c"
        tags = merge({
          Name         = join("-", [local.env, local.project, "private", "ap-southeast-1c"])
          ResourceType = "SUBNET"
        }, local.common_tags)
      }
    }
    sb   = {}
    lt   = {}
    prod = {
      "10.10.10.0/24" = {
        hosted_zone = "ap-southeast-1a"
        tags = merge({
          Name         = join("-", [local.env, local.project, "private", "ap-southeast-1a"])
          "kubernetes.io/cluster/prod-rnd-eks-cluster" = "shared"
          ResourceType = "SUBNET"
        }, local.common_tags)
      }
      "10.10.11.0/24" = {
        hosted_zone = "ap-southeast-1b"
        tags = merge({
          Name         = join("-", [local.env, local.project, "private", "ap-southeast-1b"])
          "kubernetes.io/cluster/prod-rnd-eks-cluster" = "shared"
          ResourceType = "SUBNET"
        }, local.common_tags)
      }
      "10.10.12.0/24" = {
        hosted_zone = "ap-southeast-1c"
        tags = merge({
          Name         = join("-", [local.env, local.project, "private", "ap-southeast-1c"])
          "kubernetes.io/cluster/prod-rnd-eks-cluster" = "shared"
          ResourceType = "SUBNET"
        }, local.common_tags)
      }
    }
  }
  private-subnets = lookup(local.private_subnets_dict, local.env)

  transit_gateway_id = {
    uat  = "tgw-xxxxxxxxxxxxx"
    sb   = ""
    lt   = "tgw-xxxxxxxxxxxxx"
    prod = "tgw-xxxxxxxxxxxxx"
  }
  transit-gateway-id = local.transit_gateway_id[local.env]

  tf_eks_ondemand_desired_size = {
    uat  = "0"
    prod = "2"
    sb   = "0"
    lt   = "2"
  }
  eks_ondemand_desired_size = local.tf_eks_ondemand_desired_size[local.env]
  tf_eks_ondemand_min_size = {
    uat  = "0"
    prod = "2"
    sb   = "0"
    lt   = "2"
  }
  eks_ondemand_min_size = local.tf_eks_ondemand_min_size[local.env]
  tf_eks_ondemand_max_size = {
    uat  = "0"
    prod = "10"
    sb   = "0"
    lt   = "10"
  }
  eks_ondemand_max_size = local.tf_eks_ondemand_max_size[local.env]
  tf_eks_spot_desired_size = {
    uat  = "1"
    prod = "2"
    sb   = "0"
    lt   = "0"
  }
  eks_spot_desired_size = local.tf_eks_spot_desired_size[local.env]
  tf_eks_spot_min_size = {
    uat  = "1"
    prod = "2"
    sb   = "0"
    lt   = "0"
  }
  eks_spot_min_size = local.tf_eks_spot_min_size[local.env]
  tf_eks_spot_max_size = {
    uat  = "5"
    prod = "10"
    sb   = "5"
    lt   = "10"
  }
  eks_spot_max_size = local.tf_eks_spot_max_size[local.env]
  tf_node_group_instance_types = {
    uat   = ["c5.xlarge","t3.xlarge", "t3a.xlarge"]
    prod  = ["m5.xlarge","m5d.xlarge","m5a.xlarge","m5ad.xlarge","m5n.xlarge","m5dn.xlarge","m4.xlarge","t3a.xlarge"]
    sb    = ["t3.medium","t3a.medium"]
    lt    = ["m5.xlarge","m5d.xlarge","m5a.xlarge","m5ad.xlarge","m5n.xlarge","m5dn.xlarge","m4.xlarge","t3a.xlarge"]
  }
  node_group_instance_types = local.tf_node_group_instance_types[local.env]
  tf_rnd-mw1-read = {
    prod = 1
    uat = 1
    sb = 1
    lt = 1
  }
  rnd-mw1-read = local.tf_rnd-mw1-read[local.env]

  tf_rnd-mw1-write = {
    prod = 1
    uat = 1
    sb = 1
    lt = 1
  }
  rnd-mw1-write = local.tf_rnd-mw1-write[local.env]

  tf_rnd-mw1-read-target-value = {
    prod = 70
    uat = 70
    sb = 70
    lt = 70
  }
  rnd-mw1-read-target-value = local.tf_rnd-mw1-read-target-value[local.env]

  tf_rnd-mw1-write-target-value = {
    prod = 70
    uat = 70
    sb = 70
    lt = 70
  }
  rnd-mw1-write-target-value = local.tf_rnd-mw1-write-target-value[local.env]

  tf_rnd-mw2-read = {
    prod = 1
    uat = 1
    sb = 1
    lt = 1
  }
  rnd-mw2-read = local.tf_rnd-mw2-read[local.env]

  tf_rnd-mw2-write = {
    prod = 1
    uat = 1
    sb = 1
    lt = 1
  }
  rnd-mw2-write = local.tf_rnd-mw2-write[local.env]
    tf_rnd-mw2-read-target-value = {
    prod = 70
    uat = 70
    sb = 70
    lt = 70
  }
  rnd-mw2-read-target-value = local.tf_rnd-mw2-read-target-value[local.env]
  tf_rnd-mw2-write-target-value = {
    prod = 70
    uat = 70
    sb = 70
    lt = 70
  }
  rnd-mw2-write-target-value = local.tf_rnd-mw2-write-target-value[local.env]
  tf_rnd-mw3-read = {
    prod = 1
    uat = 1
    sb = 1
    lt = 1
  }
  rnd-mw3-read = local.tf_rnd-mw3-read[local.env]

  tf_rnd-mw3-write = {
    prod = 1
    uat = 1
    sb = 1
    lt = 1
  }
  rnd-mw3-write = local.tf_rnd-mw3-write[local.env]
  tf_rnd-mw3-read-target-value = {
    prod = 70
    uat = 70
    sb = 70
    lt = 70
  }
  rnd-mw3-read-target-value = local.tf_rnd-mw3-read-target-value[local.env]

  tf_rnd-mw3-write-target-value = {
    prod = 70
    uat = 70
    sb = 70
    lt = 70
  }
  rnd-mw3-write-target-value = local.tf_rnd-mw3-write-target-value[local.env]
  tf_rnd-mw4-read = {
    prod = 1
    uat = 1
    sb = 1
    lt = 1
  }
  rnd-mw4-read = local.tf_rnd-mw4-read[local.env]
  tf_rnd-mw4-write = {
    prod = 1
    uat = 1
    sb = 1
    lt = 1
  }
  rnd-mw4-write = local.tf_rnd-mw4-write[local.env]
  tf_rnd-mw4-read-target-value = {
    prod = 70
    uat = 70
    sb = 70
    lt = 70
  }
  rnd-mw4-read-target-value = local.tf_rnd-mw4-read-target-value[local.env]

  tf_rnd-mw4-write-target-value = {
    prod = 70
    uat = 70
    sb = 70
    lt = 70
  }
  rnd-mw4-write-target-value = local.tf_rnd-mw4-write-target-value[local.env]
 
  tf_sqs1_timeout_seconds = {
    prod = 30
    uat = 60
    sb = 30
    lt = 30
  }
  sqs1_timeout_seconds = local.tf_sqs1_timeout_seconds[local.env]

  tf_sqs1_message_retention_seconds = {
    prod = 600
    uat = 3600
    sb = 600
    lt = 600
  }
  sqs1_message_retention_seconds = local.tf_sqs1_message_retention_seconds[local.env]

  tf_sqs1_receive_wait_time_seconds = {
    prod = 0
    uat = 5
    sb = 0
    lt = 0
  }
  sqs1_receive_wait_time_seconds = local.tf_sqs1_receive_wait_time_seconds[local.env]

  tf_sqs2_timeout_seconds = {
    prod = 30
    uat = 120
    sb = 30
    lt = 30
  }
  sqs2_timeout_seconds = local.tf_sqs2_timeout_seconds[local.env]

  tf_sqs2_message_retention_seconds = {
    prod = 120
    uat = 120
    sb = 120
    lt = 120
  }
  sqs2_message_retention_seconds = local.tf_sqs2_message_retention_seconds[local.env]

  tf_sqs2_receive_wait_time_seconds = {
    prod = 0
    uat = 10
    sb = 0
    lt = 0
  }
  sqs2_receive_wait_time_seconds = local.tf_sqs2_receive_wait_time_seconds[local.env]
  tf_sqs2_delay_seconds = {
    prod = 0
    uat = 0
    sb = 0
    lt = 0
  }
  sqs2_delay_seconds = local.tf_sqs2_delay_seconds[local.env]
  tf_sqs2_max_message_size = {
    prod = 1024
    uat = 1024
    sb = 1024
    lt = 1024
  }
  sqs2_max_message_size = local.tf_sqs2_max_message_size[local.env]  

  tf_sqs3_timeout_seconds = {
    prod = 30
    uat = 60
    sb = 30
    lt = 30
  }
  sqs3_timeout_seconds = local.tf_sqs3_timeout_seconds[local.env]

  tf_sqs3_message_retention_seconds = {
    prod = 600
    uat = 3600
    sb = 600
    lt = 600
  }
  sqs3_message_retention_seconds = local.tf_sqs3_message_retention_seconds[local.env]

  tf_sqs3_receive_wait_time_seconds = {
    prod = 0
    uat = 5
    sb = 0
    lt = 0
  }
  sqs3_receive_wait_time_seconds = local.tf_sqs3_receive_wait_time_seconds[local.env]

  tf_sqs3_timeout_seconds = {
    prod = 30
    uat = 120
    sb = 30
    lt = 30
  }
  sqs3_timeout_seconds = local.tf_sqs3_timeout_seconds[local.env]

  tf_sqs3_message_retention_seconds = {
    prod = 120
    uat = 120
    sb = 120
    lt = 120
  }
  sqs3_message_retention_seconds = local.tf_sqs3_message_retention_seconds[local.env]

  tf_sqs3_receive_wait_time_seconds = {
    prod = 0
    uat = 10
    sb = 0
    lt = 0
  }
  sqs3_receive_wait_time_seconds = local.tf_sqs3_receive_wait_time_seconds[local.env]
  tf_sqs3_delay_seconds = {
    prod = 0
    uat = 0
    sb = 0
    lt = 0
  }
  sqs3_delay_seconds = local.tf_sqs3_delay_seconds[local.env]
  tf_sqs3_max_message_size = {
    prod = 1024
    uat = 1024
    sb = 1024
    lt = 1024
  }
  sqs3_max_message_size = local.tf_sqs3_max_message_size[local.env]
  tf_mw4-queue_receive_wait_time_seconds = {
    prod = 0
    uat = 5
    sb = 0
    lt = 0
  }

  tf_redis-instance-type = {
    uat  = "cache.t4g.micro"
    sb   = ""
    lt   = ""
    prod = "cache.t4g.medium"
  }
  redis-instance-type = local.tf_redis-instance-type[local.env]

  tf_redis-engine-version = {
    uat = "7.0"
    sb = "7.0"
    lt = "7.0"
    prod = "7.0"
  }
  redis-engine-version = local.tf_redis-engine-version[local.env]
  tf_auth_token = {
    uat = "xxxxxxxxxxxxxxxxxxxxxxxx"
    lt = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    prod = "xxxxxxxxxxxxxxxxxxxxxxxxxxx"
  }
  auth_token = local.tf_auth_token[local.env]


  tf_boomcast_password = {
    uat = "xxxxxxxxxxxxxxxxxxx"
    lt = ""
    prod = ""
  }
  boomcast_password = local.tf_boomcast_password[local.env]

  tf_minio_secret_key= {
    uat = "12345"
    lt = ""
    prod = ""
  }
  minio_secret_key= local.tf_minio_secret_key[local.env]

  tf_minio_access_key= {
    uat = "12345"
    lt = ""
    prod = ""
  }
  minio_access_key = local.tf_minio_access_key[local.env]
  tf_report_rsa_private_key= {
    uat = "12345"
    lt = ""
    prod = ""
  }
  report_rsa_private_key = local.tf_report_rsa_private_key[local.env]  
  tf_report_rsa_public_key= {
    uat = "12345"
    lt = ""
    prod = ""
  }
  report_rsa_public_key = local.tf_report_rsa_public_key[local.env]         
}

