# Minecraft Server Automation

## Background
This repo helps with spinning up a fully automated Minecraft server using AWS, Terraform, and some shell scripting. We can do all this by running terraform apply with this repo in order to equip a security group and ec2 instance, ssh into that ec2 instance, run the config files, and start the minecraft server.

## Requirements
Before starting you need the following set up and configured on you local machine:
- Git
- Terraform
- AWS CLI
- An SSH Key Pair (this has to live locally `~/.ssh/key_pair.pem`)  
- AWS Credentials (in `~/.aws/credentials`)
* Make sure to secure your credential with `chmod 600 ~/.aws/credentials`

### Pipeline Diagram
![Pipeline overview](images/pipeline-diagram)

### Pipeline Tutorial
1. Clone the repository using the following:
   ` git clone https://github.com/mayrasolorio/minecraft-2.git `
3. Then:
   `cd minecraft-terraform`
5. Initialize terraform - this will download the AWS provider and initialize the backend:
   `terraform init`
7. Apply the changes - this applies the infrastructure and configuration changes:
   `terraform apply -var="key_name=key_pair"`
   (make sure to replace key_pair with the name of your ssh key pair)
10. Type yes when prompted
11. Terraform will ouput the public_ip once complete, but you can also view it again using:
    `terraform output -raw public_ip`
13. You can verify that the port is open by running:
    `nmap -Pn -p25565 <public_ip>` (replacing <public_ip> with the ip given)
15. You should see:
    `25565/tcp open   minecraft`


### Connect to the MC Server once it's Running!
1. Open Minecraft: Java Edition
2. Click Multiplayer and then "Add a Server"
3. Type in the server address:
   `<public_ip>:25565` (replacing <public_ip> with the ip from the previous section)
4. Click Done and then join the server!
5. You're in!



## Resources and References
- [Terraform AWS Provider] (https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Minecraft Server Download] (https://www.minecraft.net/en-us/download/server)
