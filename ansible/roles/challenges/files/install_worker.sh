#!/bin/bash

# Check if user is root
if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to install the worker"
	exit 1
fi

# Setup Docker daemon
cat <<EOF > /etc/docker/daemon.json
{
   "default-address-pools": [
        {
            "base":"172.17.0.0/12",
            "size":16
        },
        {
            "base":"192.168.0.0/16",
            "size":20
        },
        {
            "base":"10.99.0.0/16",
            "size":24
        }
    ]
}
EOF

# Restrict port 2375
iptables -A INPUT -p tcp --dport 2375 -s 192.168.0.0/16 -j REJECT
iptables -A INPUT -p tcp --dport 2375 -s 172.17.0.0/12 -j REJECT
iptables -A INPUT -p tcp --dport 2375 -s 10.99.0.0/16 -j REJECT

# Open Docker ports
sed -i 's|ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock|ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock|' /lib/systemd/system/docker.service
sed -i 's|ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock|ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375 --containerd=/run/containerd/containerd.sock|' /usr/lib/systemd/system/docker.service

# Restart Docker
systemctl daemon-reload
systemctl restart docker