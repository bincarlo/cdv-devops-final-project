locals {
  # debugging:
  ## log:
  ## less /var/log/cloud-init.log
  ## configuration schema with base64encoded custom_data:
  ## sudo less /var/lib/waagent/ovf-env.xml
  ## decoded custom_data script:
  ## sudo less /var/lib/cloud/instance/scripts/part-001
  custom_data = <<EOF
#!/bin/bash
#Log custom_data start time
sudo date > /home/azureuser/custom-data.log
# Update apt
sudo apt-get update -y
# Install git
sudo apt-get install git -y
# Go to home directory
cd /home/azureuser
# Clone git repository
git clone https://github.com/bincarlo/cdv-devops-final-project.git

# Save dotenv variables for db connection string
echo "POSTGRES_USER=${var.postgres_user}" > /home/azureuser/cdv-devops-final-project/Backend/.env
echo "POSTGRES_PASSWORD=${var.postgres_password}" >> /home/azureuser/cdv-devops-final-project/Backend/.env
echo "POSTGRES_HOST=${var.postgres_host}" >> /home/azureuser/cdv-devops-final-project/Backend/.env

# Install nginx
sudo apt-get install nginx -y
# Enable nginx
sudo systemctl enable nginx
# Start nginx
sudo systemctl start nginx

# Log custom_data finish time
date >> /home/azureuser/custom-data.log
EOF
}
