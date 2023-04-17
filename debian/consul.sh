#!/bin/bash


# This script is only designed to work with Ubuntu 20.04 and later
# It follows the official docker installation guide.
# Documentation: https://docs.docker.com/engine/install/ubuntu/

if command -v consul &> /dev/null
then
    echo "Consul found, exiting"
    exit
fi

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install consul

cat > /etc/systemd/system/consul.service << 'EOL'
[Unit]
Description="HashiCorp Consul"
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
EnvironmentFile=-/etc/consul.d/consul.env
User=consul
Group=consul
ExecStart=/usr/bin/consul agent -config-dir=/etc/consul.d/
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
KillSignal=SIGTERM
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOL

systemctl restart consul
systemctl enable --now consul
