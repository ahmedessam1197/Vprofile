#!/bin/bash
# Switch to root user
sudo -i

# Update and install necessary packages
# yum update -y

# Install Dependencies
dnf install java-11-openjdk java-11-openjdk-devel git maven wget -y
cd /tmp/
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
tar xzvf apache-tomcat-9.0.75.tar.gz
useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
mkdir -p /usr/local/tomcat
cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/
chown -R tomcat.tomcat /usr/local/tomcat

# Create tomcat systemd service file
echo "Creating tomcat systemd service file..."
cat <<EOL > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk"
Environment="CATALINA_PID=/usr/local/tomcat/temp/tomcat.pid"
Environment="CATALINA_HOME=/usr/local/tomcat"
Environment="CATALINA_BASE=/usr/local/tomcat"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

ExecStart=/usr/local/tomcat/bin/startup.sh
ExecStop=/usr/local/tomcat/bin/shutdown.sh

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd files and start & enable tomcat service
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

# Enabling the firewall and allowing port 8080
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --get-active-zones
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload

cd /home/vagrant
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
sed -i 's|backend.server.url=.*|backend.server.url=http://db01:3306|' src/main/resources/application.properties

mvn install -y
systemctl stop tomcat
rm -rf /usr/local/tomcat/webapps/ROOT*
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
systemctl start tomcat
chown tomcat.tomcat /usr/local/tomcat/webapps/ROOT.war -R
