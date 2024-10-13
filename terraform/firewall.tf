resource "linode_firewall" "dynamic_challenge_firewall" {
    label = "dynamic_challenge_firewall"

    // INBOUND (SSH & Dynamic challenges ports)
    inbound {
        label    = "allow-ssh"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "22"
        ipv4     = ["0.0.0.0/0"]
        ipv6     = ["::/0"]
    }

    inbound {
        label    = "allow-docker-socket"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "2375"
        ipv4     = ["${tolist(linode_instance.deploy_dynamic.ipv4)[1]}/32"] // Local IPv4
        ipv6     = []
    }

    inbound {
        label    = "allow-dynamic-challenges"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "10000-15000"
        ipv4     = ["0.0.0.0/0"]
        ipv6     = ["::/0"]
    }

    inbound_policy = "DROP"

    // OUTBOUND (Allow all)
    outbound_policy = "ACCEPT"

    linodes = [for instance in linode_instance.dynamic_challenges : instance.id]
}

resource "linode_firewall" "static_challenge_firewall" {
    label = "static_challenge_firewall"

    // INBOUND (SSH & Satic challenges ports)
    inbound {
        label    = "allow-ssh"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "22"
        ipv4     = ["0.0.0.0/0"]
        ipv6     = ["::/0"]
    }

    inbound {
        label    = "allow-static-challenges"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "3000-9999"
        ipv4     = ["0.0.0.0/0"]
        ipv6     = ["::/0"]
    }

    inbound_policy = "DROP"

    // OUTBOUND (Allow all)
    outbound_policy = "ACCEPT"

    linodes = [for instance in linode_instance.static_challenges : instance.id]
}

resource "linode_firewall" "deploy_dynamic_firewall" {
    label = "deploy_dynamic_firewall"

    // INBOUND (SSH & HTTPS)
    inbound {
        label    = "allow-ssh"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "22"
        ipv4     = ["0.0.0.0/0"]
        ipv6     = ["::/0"]
    }

    inbound {
        label    = "allow-https"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "443"
        ipv4     = ["0.0.0.0/0"]
        ipv6     = ["::/0"]
    }

    inbound_policy = "DROP"

    // OUTBOUND (Allow all)
    outbound_policy = "ACCEPT"

    linodes = [linode_instance.deploy_dynamic.id]
}