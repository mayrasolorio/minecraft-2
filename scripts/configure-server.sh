#!/usr/bin/env bash
set -eux

sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install -y wget

MCR_DIR="/home/ec2-user/minecraft"
sudo mkdir -p $MCR_DIR
sudo chown ec2-user:ec2-user $MCR_DIR
wget -O $MCR_DIR/server.jar \
    https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar

echo "eula=true" > $MCR_DIR/eula.txt

sudo tee /etc/systemd/system/minecraft.service > /dev/null <<'EOF'
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/minecraft
ExecStart=/usr/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui
ExecStop=/bin/kill -SIGTERM $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable minecraft
sudo systemctl start minecraft
