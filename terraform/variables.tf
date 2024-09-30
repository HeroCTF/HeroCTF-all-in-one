// Secret variables from the ".env" file
variable "LINODE_API_KEY" {
    type = string
}

variable "ROOT_PASSWORD" {
    type = string
}

variable "SSH_PUBLIC_KEY_PATH" {
    type = string
}

// Public variables with default values
variable "challenge_count" {
    type = number
    default = 2
}

variable "ssh_key_name" {
    type = string
    default = "heroctf-ssh-key"
}

variable "compute_region" {
    type = string
    default = "fr-par" // FR, Paris
}

variable "compute_instance_type" {
    type = map(string)
    default = {
        "dedicated-4gb" = "g6-dedicated-2"
        "dedicated-8gb" = "g6-dedicated-4"
        "dedicated-16gb" = "g6-dedicated-8"
    }
}

variable "compute_os" {
    type = map(string)
    default = {
      "debian12" = "linode/debian12"
    }
}