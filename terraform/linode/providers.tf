terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.29.1"
    }
  }
}

provider "linode" {
  token = var.LINODE_API_KEY
}