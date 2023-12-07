# Utilisez une image de base légère avec Python
FROM python:3.10-slim
fl
# Définissez le répertoire de travail dans le conteneur
WORKDIR /app

# Copiez les fichiers nécessaires dans le conteneur
COPY requirements.txt .

# Installez les dépendances
RUN pip install -r requirements.txt

# Copiez les fichiers de l'application dans le conteneur
COPY . .

# Exposez le port sur lequel l'application écoute
EXPOSE 5000

# Commande pour démarrer l'application quand le conteneur démarre
CMD ["python", "app.py"]
