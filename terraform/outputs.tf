output "challenges_ip_addresses" {
    value = {
        for instance in linode_instance.challenges : instance.label => instance.ipv4
    }
}

output "ctfd_ip_address" {
    value = linode_instance.ctfd.ipv4
}