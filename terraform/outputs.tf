output "compute_ip_addresses" {
    value = {
        for instance in linode_instance.challenges : instance.label => instance.ipv4
    }
}