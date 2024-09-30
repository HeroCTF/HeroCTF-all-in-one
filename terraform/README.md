# HeroCTF - Terraform

## Getting started

### Installation

Install `terraform`:

```bash
# debian
sudo apt update && sudo apt install terraform
# arch
sudo pacman -S terraform
```

### Configuration

Copy the [.env.sample](.env.sample) file to `.env` and fill the environment variables.

- `TF_VAR_LINODE_API_KEY`: Create an `API Token` at [https://cloud.linode.com/profile/tokens](https://cloud.linode.com/profile/tokens).
- `TF_VAR_ROOT_PASSWORD`: Generate a random password, i.e. `openssl rand -hex 32`.
- `TF_VAR_SSH_PUBLIC_KEY_PATH`: Path of the SSH public key, i.e. `~/.ssh/heroctf/linode.pub`.

```bash
mkdir -p ~/.ssh/heroctf/
ssh-keygen -f ~/.ssh/heroctf/linode -C 'heroctf@challenge'
chmod 600 ~/.ssh/heroctf/linode
```

### Usage

Initialize, plan & apply `terraform`:

```bash
source .env
terraform init
terraform plan
terraform apply

ssh root@<public_ip_v4_address> -i ~/.ssh/heroctf/linode
```

Plan and destroy `terraform`:

```bash
source .env
terraform plan -destroy
terraform destroy
```