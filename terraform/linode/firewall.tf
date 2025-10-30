resource "linode_firewall" "dynamic_challenge_firewall" {
  count = length(linode_instance.deploy_dynamic) > 0 ? 1 : 0
  label = "dynamic_challenge_firewall"

  // INBOUND (SSH, Docker TCP socket)
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
    // IPv4 from the VPC
    ipv4 = flatten([
      for instance in linode_instance.deploy_dynamic : [
        for interface in instance.interface : "${interface.ipv4[0].vpc}/32"
        if interface.purpose == "vpc"
      ]
    ])
  }

  inbound {
    label    = "allow-cadvisor-node_exporter"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1080,9100"
    // IPv4 from the VPC
    ipv4 = flatten([
      for instance in linode_instance.deploy_dynamic : [
        for interface in instance.interface : "${interface.ipv4[0].vpc}/32"
        if interface.purpose == "vpc"
      ]
    ])
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
  count = length(linode_instance.deploy_dynamic) > 0 ? 1 : 0
  label = "static_challenge_firewall"

  // INBOUND (SSH, HTTP/HTTPs, cAdvisor, 3000-9999 ports)
  inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound {
    label    = "allow-cadvisor-node_exporter"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1080,9100"
    // IPv4 from the VPC
    ipv4 = flatten([
      for instance in linode_instance.deploy_dynamic : [
        for interface in instance.interface : "${interface.ipv4[0].vpc}/32"
        if interface.purpose == "vpc"
      ]
    ])
  }

  inbound {
    label    = "allow-static-http-https"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80,443"
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
  count = length(linode_instance.deploy_dynamic) > 0 ? 1 : 0
  label = "deploy_dynamic_firewall"

  // INBOUND (SSH, HTTPS)
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

  inbound {
    label    = "allow-grafana"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "9000"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound_policy = "DROP"

  // OUTBOUND (Allow all)
  outbound_policy = "ACCEPT"

  linodes = [for instance in linode_instance.deploy_dynamic : instance.id]
}

resource "linode_firewall" "pre_ctfd_firewall" {
  label = "pre_ctfd_firewall"

  // INBOUND (SSH, HTTPS)
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

  linodes = [for instance in linode_instance.pre_ctfd : instance.id]
}