#! /bin/sh
#sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Azure Virtual Machine(Machine1) deployed with Terraform</h1>" | sudo tee /var/www/html/index.html