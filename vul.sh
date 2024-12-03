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

# Lancer le conteneur Juice Shop
read -p "Souhaitez-vous lancer le conteneur Juice Shop maintenant ? (y/n) : " launch_juice
if [ "$launch_juice" == "y" ]; then
  echo "Lancement du conteneur Juice Shop sur le port 3000..."
  sudo docker run -dt -p 3000:3000 bkimminich/juice-shop
else
  echo "Installation terminée. Vous pouvez lancer Juice Shop plus tard avec la commande suivante :"
  echo "sudo docker run --dt -p 127.0.0.1:3000:3000 bkimminich/juice-shop"
fi

echo "Script terminé."
