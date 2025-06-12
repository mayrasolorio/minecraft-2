# Minecraft Server Automation

## Requirements
Before starting you need the following:
- Git
- Terraform
- AWS CLI
- An SSH Key Pair (this has to live locally `~/.ssh/key_pair.pem`)  
- AWS Credentials (in `~/.aws/credentials`)


flowchart LR
  A[git clone repo] --> B[terraform init]
  B --> C[terraform apply -var="key_name=<key_pair>"]
  C --> D[AWS: create SG & EC2]
  D --> E[Terraform provisioners SSH → run configure-server.sh]
  E --> F[Systemd starts Minecraft server]
  F --> G[Server listening on port 25565]
