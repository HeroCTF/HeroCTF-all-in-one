resource "linode_sshkey" "ctf_ssh_key" {
  label   = var.ssh_key_name
  ssh_key = chomp(file(var.SSH_PUBLIC_KEY_PATH))
}

resource "linode_instance" "static_challenges" {
  count = var.static_challenges_count

  label           = "static-challenge-${count.index + 1}"
  image           = var.compute_os
  region          = var.compute_region
  type            = var.compute_instance_type["dedicated-8gb"]
  authorized_keys = [linode_sshkey.ctf_ssh_key.ssh_key]
  root_pass       = var.ROOT_PASSWORD

  tags       = ["challenge"]
  swap_size  = 4096 // 4GB
  private_ip = true

  interface {
    purpose = "public"
  }

  interface {
    purpose   = "vpc"
    subnet_id = linode_vpc_subnet.ctf_vpc_subnet.id
  }
}

resource "linode_instance" "dynamic_challenges" {
  count = var.dynamic_challenges_count

  label           = "dynamic-challenge-${count.index + 1}"
  image           = var.compute_os
  region          = var.compute_region
  type            = var.compute_instance_type["dedicated-8gb"]
  authorized_keys = [linode_sshkey.ctf_ssh_key.ssh_key]
  root_pass       = var.ROOT_PASSWORD

  tags       = ["challenge"]
  swap_size  = 4096 // 4GB
  private_ip = true

  interface {
    purpose = "public"
  }

  interface {
    purpose   = "vpc"
    subnet_id = linode_vpc_subnet.ctf_vpc_subnet.id
  }
}

resource "linode_instance" "deploy_dynamic" {
  count = var.deploy_dynamic_count

  label           = "deploy_dynamic"
  image           = var.compute_os
  region          = var.compute_region
  type            = var.compute_instance_type["dedicated-8gb"]
  authorized_keys = [linode_sshkey.ctf_ssh_key.ssh_key]
  root_pass       = var.ROOT_PASSWORD

  tags       = ["deploy_dynamic"]
  swap_size  = 4096 // 4GB
  private_ip = true

  interface {
    purpose = "public"
  }

  interface {
    purpose   = "vpc"
    subnet_id = linode_vpc_subnet.ctf_vpc_subnet.id
  }
}

resource "linode_instance" "pre_ctfd" {
  count = var.pre_ctfd_count

  label           = "pre_ctfd"
  image           = var.compute_os
  region          = var.compute_region
  type            = var.compute_instance_type["dedicated-8gb"]
  authorized_keys = [linode_sshkey.ctf_ssh_key.ssh_key]
  root_pass       = var.ROOT_PASSWORD

  tags       = ["ctfd"]
  swap_size  = 4096 // 4GB
  private_ip = true

  interface {
    purpose = "public"
  }

  interface {
    purpose   = "vpc"
    subnet_id = linode_vpc_subnet.ctf_vpc_subnet.id
  }
}