terraform {
    required_providers {
        linode = {
            source  = "linode/linode"
            version = "2.5.2"
        }
    }
}

provider "linode" {
    token = var.LINODE_API_KEY
}