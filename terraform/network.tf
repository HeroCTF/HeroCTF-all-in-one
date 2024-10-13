
resource "linode_vpc" "ctf_vpc" {
    label       = "ctf-vpc"
    region      = var.compute_region
    description = "VPS for the CTF"
}

resource "linode_vpc_subnet" "ctf_vpc_subnet" {
    vpc_id = linode_vpc.ctf_vpc.id
    label  = "ctf-vpc-subnet"
    ipv4   = "10.0.1.0/24"
}
