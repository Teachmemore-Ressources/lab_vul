#!/bin/bash

# Mettre à jour le système et installer les dépendances
echo "Mise à jour des paquets et installation des dépendances..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Ajouter la clé GPG officielle de Docker
echo "Ajout de la clé GPG officielle de Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Ajouter le dépôt officiel de Docker
echo "Ajout du dépôt Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mettre à jour les sources et installer Docker
echo "Installation de Docker..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Vérification de l'installation de Docker
echo "Vérification de l'installation de Docker..."
sudo docker --version

# Lancer le conteneur Juice Shop
echo "Lancement du conteneur Juice Shop sur le port 3000..."
sudo docker run --rm -p 127.0.0.1:3000:3000 bkimminich/juice-shop

echo "Déploiement terminé. Vous pouvez accéder à Juice Shop via http://127.0.0.1:3000"
