#!/bin/bash

# Mettre à jour le système
echo "Mise à jour des paquets..."
sudo apt update

# Vérification de l'option d'installation
echo "Choisissez la version de Docker à installer :"
echo "1) docker.io (version Debian native)"
echo "2) docker-ce (version depuis le dépôt officiel Docker)"
read -p "Entrez votre choix (1 ou 2) : " choice

if [ "$choice" -eq 1 ]; then
  # Installation de docker.io
  echo "Installation de docker.io..."
  sudo apt install -y docker.io
elif [ "$choice" -eq 2 ]; then
  # Ajouter le dépôt Docker officiel pour Debian
  echo "Ajout du dépôt Docker pour Debian (bookworm)..."
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list

  # Ajouter la clé GPG
  echo "Ajout de la clé GPG..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  # Mettre à jour et installer docker-ce
  echo "Mise à jour des dépôts..."
  sudo apt update
  echo "Installation de docker-ce..."
  sudo apt install -y docker-ce docker-ce-cli containerd.io
else
  echo "Choix invalide. Le script va quitter."
  exit 1
fi

# Activer et démarrer Docker
echo "Activation et démarrage de Docker..."
sudo systemctl enable docker --now

# Vérifier l'installation de Docker
echo "Vérification de l'installation de Docker..."
docker --version
if [ $? -ne 0 ]; then
  echo "Docker n'a pas été installé correctement. Vérifiez les étapes précédentes."
  exit 1
fi

# Ajouter l'utilisateur au groupe Docker (optionnel)
read -p "Souhaitez-vous utiliser Docker sans sudo ? (y/n) : " add_to_group
if [ "$add_to_group" == "y" ]; then
  echo "Ajout de l'utilisateur au groupe Docker..."
  sudo usermod -aG docker $USER
  echo "Déconnexion requise pour appliquer les changements. Veuillez vous déconnecter et reconnecter."
fi

# Installer Docker Compose
echo "Installation de Docker Compose..."
sudo apt install docker-compose -y
# Vérifier l'installation de Docker Compose
echo "Vérification de l'installation de Docker Compose..."
docker-compose --version
if [ $? -ne 0 ]; then
  echo "Docker Compose n'a pas été installé correctement. Vérifiez les étapes précédentes."
  exit 1
fi

# Lancer le conteneur Juice Shop avec Docker Compose
read -p "Souhaitez-vous créer un fichier Docker Compose pour Juice Shop et le lancer ? (y/n) : " setup_compose
if [ "$setup_compose" == "y" ]; then
  echo "Création du fichier docker-compose.yml..."
  cat <<EOL > docker-compose.yml
version: '3'
services:
  juice-shop:
    image: bkimminich/juice-shop
    ports:
      - "3000:3000"
EOL
  echo "Lancement de Juice Shop avec Docker Compose..."
  sudo docker-compose up -d
else
  echo "Installation terminée. Vous pouvez utiliser Docker Compose plus tard avec :"
  echo "sudo docker-compose up -d"
fi

echo "Script terminé. Profitez de votre environnement Docker et Docker Compose !"
