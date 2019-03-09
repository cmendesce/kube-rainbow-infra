variable "aws_amis" {
  description = "The AMI to use for setting up the instances."
  default = {
    # Ubuntu Xenial 16.04 LTS
    "eu-west-1" = ""
    "eu-west-2" = ""
    "eu-central-1" = ""
    "us-east-1" = "ami-0f9cf087c1f27d9b1"
    "us-east-2" = ""
    "us-west-1" = ""
    "us-west-2" = ""
  }
}

data "aws_availability_zones" "available" {}

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "instance_user" {
  description = "The user account to use on the instances to run the scripts."
  default     = "ubuntu"
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default     = "k8s"
}

variable "master_instance_type" {
  description = "The instance type to use for the Kubernetes master."
  default     = "t3.small"
}

variable "node_instance_type" {
  description = "The instance type to use for the Kubernetes nodes."
  default     = "t3.small"
}

variable "node_count" {
  description = "The number of nodes in the cluster."
  default     = "1"
}

variable "private_key_path" {
  description = "The private key for connection to the instances as the user. Corresponds to the key_name variable."
  default     = "k8s.pem"
}
