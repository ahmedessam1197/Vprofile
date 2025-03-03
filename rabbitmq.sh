#!/bin/bash
# Switch to root user
sudo -i

# Update and install necessary packages
# yum update -y

# Install Dependencies
sudo yum install wget -y
cd /tmp/
dnf -y install centos-release-rabbitmq-38
dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
systemctl enable --now rabbitmq-server

# Setup access to user test and make it admin
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo systemctl restart rabbitmq-server

# Starting the firewall and allowing the port 5672
firewall-cmd --add-port=5672/tcp
firewall-cmd --runtime-to-permanent

sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server