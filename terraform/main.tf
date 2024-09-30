resource "linode_sshkey" "challenge_ssh_key" {
    label = var.ssh_key_name
    ssh_key = chomp(file(var.SSH_PUBLIC_KEY_PATH))
}

resource "linode_instance" "challenges" {
    count           = var.challenge_count

    label           = "challenge-${count.index + 1}"
    image           = var.compute_os["debian12"]
    region          = var.compute_region
    type            = var.compute_instance_type["dedicated-4gb"]
    authorized_keys = [linode_sshkey.challenge_ssh_key.ssh_key]
    root_pass       = var.ROOT_PASSWORD

    tags       = ["challenge"]
    swap_size  = 4096 // 4GB
    private_ip = true
}