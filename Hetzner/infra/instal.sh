#!/bin/bash

function sys_setup()
{
    echo "starting upgade process..."
    apt update -y -q && apt upgrade -y -q
    echo "Updated & Upgrade finished, please restart system soon"
}

function setup_packages()
{
    apt install -y nginx fail2ban build-essential docker.io
    echo "setting up services..."
    systemctl enable nginx
    systemctl enable fail2ban
    echo "starting services..."
    systemctl start fail2ban
    systemctl start nginx
}

function install_uv()
{
    curl -LsSf https://astral.sh/uv/install.sh | sh
}

function restart()
{
    wall "Restarting system affter setup"
    shutdown -r now
}


# were the fun beggins...
echo "starting server prep..."

sys_setup
setup_packages
restart
