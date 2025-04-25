#!/bin/bash

# Script de création d'une instance EC2 avec AWS CLI

# Définition des variables
IMAGE_ID="ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI (HVM), SSD Volume Type
INSTANCE_TYPE="t2.micro"
KEY_NAME="ma_cle_ssh"
SECURITY_GROUP="sg-0123456789abcdef0"
SUBNET_ID="subnet-0123456789abcdef0"

# Création de l'instance EC2
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $IMAGE_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SECURITY_GROUP \
    --subnet-id $SUBNET_ID \
    --output text \
    --query 'Instances[0].InstanceId')

echo "Instance EC2 créée avec l'ID : $INSTANCE_ID"

# Attente que l'instance soit en état 'running'
echo "Attente du démarrage de l'instance..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Récupération de l'adresse IP publique de l'instance
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --output text \
    --query 'Reservations[0].Instances[0].PublicIpAddress')

echo "L'instance EC2 est prête !"
echo "Adresse IP publique : $PUBLIC_IP"