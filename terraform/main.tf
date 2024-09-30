resource "linode_sshkey" "ctf_ssh_key" {
    label = var.ssh_key_name
    ssh_key = chomp(file(var.SSH_PUBLIC_KEY_PATH))
}

resource "linode_instance" "challenges" {
    count           = var.challenges_count

    label           = "challenge-${count.index + 1}"
    image           = var.compute_os["debian12"]
    region          = var.compute_region
    type            = var.compute_instance_type["dedicated-8gb"]
    authorized_keys = [linode_sshkey.ctf_ssh_key.ssh_key]
    root_pass       = var.ROOT_PASSWORD

    tags       = ["challenge"]
    swap_size  = 4096 // 4GB
    private_ip = true
}

resource "linode_instance" "ctfd" {
    label           = "pre-ctfd" // CTFd instance for registration (not the final one)
    image           = var.compute_os["debian12"]
    region          = var.compute_region
    type            = var.compute_instance_type["dedicated-8gb"]
    authorized_keys = [linode_sshkey.ctf_ssh_key.ssh_key]
    root_pass       = var.ROOT_PASSWORD

    tags       = ["ctfd"]
    swap_size  = 4096 // 4GB
    private_ip = true
}