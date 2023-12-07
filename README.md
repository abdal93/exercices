# exercices

1) Créer une petite application web en utilisant Flask
Pour créer une petite application web, nous allons utiliser le langage Python et le framework Flask.
1.1) Créer un projet Python
Ouvrez un terminal et créez un nouveau projet Python et placez vous dans ce nouveau projet :

mkdir hello-world
cd hello-world

1.2) Créer l'application Flask
Vous pouvez l'installer en utilisant la commande suivante :

pip install flask

Ensuite, créez un fichier appelé app.py:

touch app.py
nano app.py

Ajoutez le code suivant pour une application "Hello World" de base :

from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return "Hello, World!"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')

Exécutez l'application pour vous assurer qu'elle fonctionne correctement :

python app.py

Vous devriez voir le message "Hello, World!" lorsque vous accédez à http://127.0.0.1:5000/ dans votre navigateur!

2) Conteneurisation avec Docker
2.1) Créer un Dockerfile
Créez un fichier appelé Dockerfile à la racine de votre projet:

touch Dockerfile
nano Dockerfile

Ajoutez le contenu suivant pour spécifier comment Docker doit construire l'image de votre application :

# Utilisez une image de base légère avec Python
FROM python:3.10-slim

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copiez les fichiers nécessaires dans le conteneur
COPY requirements.txt .

# Installez les dépendances
RUN pip install -r requirements.txt

#Copiez les fichers de l'application dans le conteneur
COPY . .

# Commande pour démarrer l'application
CMD ["python3", "app.py"]

Assurez-vous que le fichier requirements.txt est présent dans le même répertoire que le Dockerfile. Si vous n'en avez pas, vous pouvez le créer pour spécifier les dépendances nécessaires. Dans notre cas, cela pourrait ressembler à ceci :

touch requirements.txt
nano requirements.txt

Flask==2.1.0

Assurez-vous que Docker est installé sur votre machine. Vous pouvez suivre les instructions d'installation sur le site officiel!
À la racine de votre projet, exécutez la commande suivante pour construire l'image Docker :

docker build -t hello world .

Vérifiez que l'image a été créée avec succès :

docker images

Pour exécuter l'image Docker, exécutez la commande suivante :

docker run -p 5000:5000 hello-world

Vous pouvez maintenant accéder à http://127.0.0.1:5000/ en ouvrant un navigateur et vous devriez voir le message "Hello, World!".

3) déploiement Kubernetes
3.1) Écrire le fichier de déploiement Kubernetes (deployment.yaml)
Créez un fichier appelé deployment.yaml:

touch deployment.yaml
nano deployment.yaml

Ajoutez le contenu suivant pour définir le déploiement de votre application Flask:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 3 # Nombre de répliques (ajuster selon vos besoins)
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-world
        image: hello-world
        ports:
        - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: hello-world
spec:
  selector:
    app: hello-world
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000 # Port du conteneur
  type: LoadBalancer # Type de service pour accéder à l'application depuis l'extérieur

  3.2) Déployer sur Kubernetes
Assurez-vous que kubectl (l'outil de ligne de commande Kubernetes) est installé sur votre machine! Exécutez la commande suivante pour déployer votre application sur Kubernetes :

kubectl apply -f deployment.yaml

3.3) Vérifiez que les pods sont en cours d'exécution :

kubectl get pods

4) configuration du pipeline CI/CD avec GitLab CI
4.1) Configurer le pipeline CI/CD avec GitLab CI
Créez un fichier nommé ‘.gitlab-ci.yml’

touch .gitlab-ci.yml
nano .gitlab-ci.yml

Ajoutez le contenu suivant :

image: python:3.10-slim

stages:
  - build
  - push
  - deploy

variables:
  DOCKER_IMAGE: hello-world
  KUBE_DEPLOYMENT_FILE: deployment.yaml
  KUBE_NAMESPACE: default  # Remplacez par votre namespace Kubernetes

before_script:
  - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY

build:
  stage: build
  script:
    - echo "Building Docker image"
    - docker build -t hello-world .

push:
  stage: push
  script:
    - echo "Pushing Docker image to registry"
    - docker push hello-world

deploy:
  stage: deploy
  script:
    - echo "Deploying application to Kubernetes"
    - kubectl apply -f deployment.yaml

Si vous utilisez un namespace Kubernetes différent de default, remplacez default dans la variable KUBE_NAMESPACE par votre propre namespace.
4.2) Configurer les variables d'environnement dans GitLab
Dans votre projet GitLab, accédez à "Settings" -> "CI / CD" -> "Variables".

Ajoutez les variables suivantes :
CI_REGISTRY_USER: Votre nom d'utilisateur du registre Docker
CI_REGISTRY_PASSWORD: Votre mot de passe du registre Docker

4.3) Pousser des modifications et déclencher le pipeline
Ajoutez, committez et poussez votre fichier .gitlab-ci.yml ainsi que toute autre modification nécessaire.
Le pipeline GitLab CI devrait se déclencher automatiquement. Vous pouvez suivre son progrès dans l'interface GitLab.
