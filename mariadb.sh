#!/bin/bash
# Switch to root user
sudo -i

# Update and install necessary packages
# yum update -y
yum install epel-release -y

# Install Maria DB Package
yum install git mariadb-server -y
Starting & enabling mariadb-server
systemctl start mariadb
systemctl enable mariadb

# Run mysql_secure_installation script automatically
expect <<EOF
spawn mysql_secure_installation
expect "Enter current password for root (enter for none):"
send "\r"
expect "Set root password? \[Y/n\]"
send "y\r"
expect "New password:"
send "admin123\r"
expect "Re-enter new password:"
send "admin123\r"
expect "Remove anonymous users? \[Y/n\]"
send "y\r"
expect "Disallow root login remotely? \[Y/n\]"
send "y\r"
expect "Remove test database and access to it? \[Y/n\]"
send "y\r"
expect "Reload privilege tables now? \[Y/n\]"
send "y\r"
expect eof
EOF

# Configure MariaDB: Create database and user
mysql -u root -padmin123 <<MYSQL_SCRIPT
CREATE DATABASE accounts;
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Download source code and initialize database
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql
systemctl restart mariadb

# Starting the firewall and allowing the mariadb to access from port no. 3306
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload

systemctl restart mariadb