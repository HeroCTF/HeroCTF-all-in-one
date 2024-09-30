resource "linode_firewall" "challenge_firewall" {
    label = "challenge_firewall"

    // INBOUND (SSH & Challenges ports)
    inbound {
        label    = "allow-ssh"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "22"
        ipv4     = ["0.0.0.0/0"]
        ipv6     = ["::/0"]
    }

    inbound {
        label    = "allow-deploy-dynamic"
        action   = "ACCEPT"
        protocol = "TCP"
        ports    = "10000-15000"
        ipv4     = ["0.0.0.0/0"]
        ipv6     = ["::/0"]
    }

    inbound_policy = "DROP"

    // OUTBOUND (Allow all)
    outbound_policy = "ACCEPT"

    linodes = [for instance in linode_instance.challenges : instance.id]
}