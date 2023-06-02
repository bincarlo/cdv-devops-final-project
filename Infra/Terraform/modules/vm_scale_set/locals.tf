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

# Update OpenSSL
sudo NEEDRESTART_MODE=a apt-get upgrade openssl -y

# Install pip3
sudo apt-get install python3-pip -y
# Set python3.10 as default
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
# Install NPM
sudo apt-get install npm -y
# Install NodeJS
sudo apt-get install nodejs -y
# install React
sudo npm install -g create-react-app

# Go to repository
cd /home/azureuser/cdv-devops-final-project/Backend
# Install requirements
pip3 install -r requirements.txt
# Resolve JWT error
pip uninstall JWT -y
pip uninstall PyJWT -y
pip install PyJWT
# Start python3 backend server
nohup python3 main.py &

# Go to repository
cd ../Frontend
# Install requirements
npm install
# Build react
npm run build
# Copy build to nginx
sudo cp -r build/* /var/www/html/

# Copy nginx config
sudo cp ../Infra/Legacy/nginx.conf /etc/nginx/sites-available/default
# Restart nginx
sudo systemctl restart nginx

# Log custom_data finish time
date >> /home/azureuser/custom-data.log
EOF
}
