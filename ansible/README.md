# Deployment with Ansible

## Getting started

### Installation

```bash
python3 -m pip install ansible
```

### Inventory

Update the [inventories/](inventories/) folder with your SSH information.

Configuration your ssh client configuration at `~/.ssh/config`.

```bash
Host heroctf-ctfd
    User root
    Hostname XXX
    Port 22
    IdentityFile /home/xanhacks/.ssh/heroctf/linode

Host heroctf-challenge-1
    User root
    Hostname XXX
    Port 22
    IdentityFile /home/xanhacks/.ssh/heroctf/linode

Host heroctf-challenge-2
    User root
    Hostname XXX
    Port 22
    IdentityFile /home/xanhacks/.ssh/heroctf/linode

# [...]
```

Check the SSH connection is working and accept all SSH fingerprints.

```bash
ansible -i inventories/dev -m ping all -v
ansible -i inventories/prod -m ping all -v
```

## Roles

### Prerequisites

#### Features

1. Update APT cache & install usefull packages (`git`, `curl`, `vim`...).
2. Configure the VM timezone, hostname and create a low privileged account.
3. Install and start `docker` & `docker-compose`.

### CTFd

#### Features

1. Clone CTFd at a specific version.
2. Overwrite the default `docker-compose.yml` and `http.conf` with enhanced configuration (HTTPs and better performance).
3. Upload HTTPs certificates.
4. (optional) Extract custom CTFd theme.
5. (optional) Enable first blood Discord webhook.

> Generate your HTTPs certificates using certbot: `cd /tmp && certbot certonly --manual --preferred-challenges dns -d 'ctf.heroctf.fr' --work-dir $(pwd) --logs-dir $(pwd) --config-dir $(pwd) && cp /tmp/live/ctf.heroctf.fr/*.pem ./roles/ctfd/files/certs/`

#### Setup & Run

1. Configure the `ctfd` role at [./group_vars/ctfd.yml](./group_vars/ctfd.yml).
2. Add `fullchain.pem` and `privkey.pem` to [./roles/ctfd/files/certs](./roles/ctfd/files/certs).
3. Configure the [./roles/ctfd/files/.env.sample](./roles/ctfd/files/.env.sample) file to `.env`.
4. (optional) Add CTFd Theme `hacker_theme.zip` at [./roles/ctfd/files/](./roles/ctfd/files/).

```bash
ansible-playbook ctfd.yml -i inventories/dev
ansible-playbook ctfd.yml -i inventories/prod
```

### Challenges

#### Features

1. Upload and configure the Github SSH private key to see private repositories.
2. Clone the challenge repository.

> You can create a Github SSH key for a repository under the `Settings > Deploy keys` tab, then click on `Add deploy key`.

#### Setup & Run

1. Configure `challenges` role at [./group_vars/challenges.yml](./group_vars/challenges.yml).
2. Add your Github private SSH key to [./roles/challenges/files/](./roles/challenges/files/) under the name `github.key`.

```bash
ansible-playbook challenges.yml -i inventories/dev
ansible-playbook challenges.yml -i inventories/prod
```

## Linter

Use [ansible-lint](https://github.com/ansible/ansible-lint) to checks playbooks for practices and behavior that could potentially be improved.

```bash
python3 -m pip install ansible-lint
ansible-lint
```

## About

Tested on debian 12 and 13.