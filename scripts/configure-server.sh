#!/bin/bash
# 1) Update & install Java/wget
sudo yum update -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install -y wget

# 2) Prepare dir & download server
cd /home/ec2-user
mkdir -p minecraft && cd minecraft
wget -O server.jar https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar
echo "eula=true" > eula.txt

# 3) Create systemd unit
sudo tee /etc/systemd/system/minecraft.service > /dev/null <<EOF
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/minecraft
ExecStart=/usr/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui
ExecStop=/bin/kill -SIGTERM \$MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# 4) Enable & start
sudo systemctl daemon-reload
sudo systemctl enable --now minecraft
