// Private variables (.env file)
variable "LINODE_API_KEY" {
    type = string
    description = "Linode API key"
    sensitive = true
}

variable "ROOT_PASSWORD" {
    type = string
    description = "Root password for the Linode instances"
    sensitive = true
}

variable "SSH_PUBLIC_KEY_PATH" {
    type = string
    description = "Path to the public SSH key"
}

// Public variables
variable "static_challenges_count" {
    type = number
    description = "Number of static challenge instances"
}

variable "dynamic_challenges_count" {
    type = number
    description = "Number of dynamic challenge instances"
}

variable "ssh_key_name" {
    type = string
    description = "Name of the SSH key"
    default = "ctf-ssh-key"
}

variable "compute_region" {
    type = string
    description = "Linode instances geographical region"
    default = "fr-par" // FR, Paris
}

variable "compute_instance_type" {
    type = map(string)
    description = "Linode instances specifications"
    default = {
        "dedicated-4gb" = "g6-dedicated-2"
        "dedicated-8gb" = "g6-dedicated-4"
        "dedicated-16gb" = "g6-dedicated-8"
    }
}

variable "compute_os" {
    type = map(string)
    description = "Linode instances operating system"
    default = {
      "debian12" = "linode/debian12"
    }
}