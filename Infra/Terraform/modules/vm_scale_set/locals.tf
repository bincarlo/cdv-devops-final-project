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
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
EOF
}
