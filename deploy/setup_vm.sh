#!/bin/bash
# setup_vm.sh
# Run this inside the Ubuntu VM after cloning the repository

set -e

REPO_DIR="/var/www/UnifiedAuthGateway"

echo "Updating system packages..."
sudo apt-get update
sudo apt-get install -y python3-pip python3-venv openjdk-17-jdk nginx git

echo "Setting up repository permissions..."
sudo mkdir -p /var/www
sudo chown -R ubuntu:ubuntu /var/www
# Assuming repo is cloned to /var/www/UnifiedAuthGateway
if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning repository..."
    git clone https://github.com/AK20202007/UnifiedAuthGateway.git $REPO_DIR
fi

cd $REPO_DIR

echo "Setting up Auth Server..."
cd auth_server
python3 -m venv venv
source venv/bin/activate
pip install gunicorn django django-oauth-toolkit pyjwt cryptography jwcrypto
python manage.py migrate
# Ensure private.pem and public.pem are present (for production, fetch from Azure Key Vault)
if [ ! -f "private.pem" ]; then
    python generate_keys.py
fi
cd ..

echo "Setting up Django API..."
cd django_api
python3 -m venv venv
source venv/bin/activate
pip install gunicorn django djangorestframework django-oauth-toolkit pyjwt cryptography
python manage.py migrate
cd ..

echo "Setting up Spring Boot API..."
cd springboot_api
chmod +x mvnw
./mvnw clean package -DskipTests
cd ..

echo "Linking systemd services..."
sudo cp deploy/systemd/*.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable auth_server django_api springboot_api
sudo systemctl start auth_server django_api springboot_api

echo "Configuring NGINX..."
sudo cp deploy/nginx/unified_auth.conf /etc/nginx/sites-available/
sudo ln -sf /etc/nginx/sites-available/unified_auth.conf /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

echo "VM Setup Complete! Services are running behind NGINX."
