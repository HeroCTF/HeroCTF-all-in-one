output "static_challenges_ip_addresses" {
    value = {
        for instance in linode_instance.static_challenges : instance.label => instance.ipv4
    }
}

output "dynamic_challenges_ip_addresses" {
    value = {
        for instance in linode_instance.dynamic_challenges : instance.label => instance.ipv4
    }
}

output "deploy_dynamic_ip_address" {
    value = linode_instance.deploy_dynamic.ipv4
}
