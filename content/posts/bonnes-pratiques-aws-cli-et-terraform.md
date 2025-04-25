# Les bonnes pratiques AWS CLI et Terraform

## Introduction

Dans le monde du cloud computing, l'automatisation et la gestion efficace de l'infrastructure sont essentielles. Deux outils populaires pour accomplir ces tâches sont l'AWS CLI (Command Line Interface) et Terraform. Ce post explorera les bonnes pratiques pour utiliser ces outils, en mettant l'accent sur la création d'instances EC2.

## Partie 1 : AWS CLI avec Docker

### Avantages de l'utilisation de Docker pour l'AWS CLI

1. **Isolation** : Docker isole l'environnement AWS CLI, évitant les conflits avec d'autres versions ou dépendances sur votre système.
2. **Portabilité** : Le conteneur Docker peut être exécuté sur n'importe quel système prenant en charge Docker.
3. **Gestion des versions** : Facilite l'utilisation de versions spécifiques de l'AWS CLI.
4. **Sécurité** : Limite l'exposition des credentials AWS à un environnement contrôlé.

### Prérequis

- Docker installé sur votre machine
- Compte AWS et clés d'accès

### Création et utilisation d'un conteneur Docker avec AWS CLI

1. Créez un Dockerfile :

```dockerfile
FROM amazon/aws-cli

WORKDIR /aws

CMD ["/bin/bash"]
```

2. Construisez l'image Docker :

```bash
docker build -t my-aws-cli .
```

3. Exécutez le conteneur :

```bash
docker run -it --rm \
    -v ${PWD}:/aws \
    -e AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY \
    -e AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY \
    my-aws-cli
```

### Exemple : Création d'une instance EC2

Dans le conteneur Docker, exécutez :

```bash
aws ec2 run-instances \
    --image-id ami-xxxxxxxx \
    --instance-type t2.micro \
    --key-name MyKeyPair \
    --security-group-ids sg-xxxxxxxx \
    --subnet-id subnet-xxxxxxxx
```

### Bonnes pratiques pour l'AWS CLI avec Docker

1. **Gestion des credentials** : Utilisez des variables d'environnement ou AWS CLI profiles plutôt que de coder en dur les credentials.
2. **Utilisation de scripts** : Créez des scripts shell pour automatiser les tâches complexes.
3. **Logging** : Activez le logging AWS CLI pour le débogage.
4. **Contrôle de version** : Versionnez vos Dockerfiles et scripts dans un système comme Git.

## Partie 2 : Utilisation de Terraform

Terraform est un outil d'Infrastructure as Code (IaC) qui permet de gérer et de provisionner l'infrastructure cloud de manière déclarative. Il offre une alternative puissante à l'utilisation directe de l'AWS CLI pour la gestion de l'infrastructure.

### Prérequis pour Terraform

- Terraform installé sur votre machine
- Compte AWS et clés d'accès

### Configuration de Terraform pour AWS

1. Créez un fichier `main.tf` avec le contenu suivant :

```hcl
provider "aws" {
  region = "us-west-2"  # Remplacez par votre région préférée
}

resource "aws_instance" "example" {
  ami           = "ami-xxxxxxxx"  # Remplacez par l'ID de l'AMI souhaité
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance"
  }
}
```

2. Initialisez Terraform :

```bash
terraform init
```

3. Planifiez les changements :

```bash
terraform plan
```

4. Appliquez les changements :

```bash
terraform apply
```

### Avantages de Terraform

1. **Gestion de l'état** : Terraform garde une trace de l'état de votre infrastructure, ce qui facilite les mises à jour et les suppressions.
2. **Reproductibilité** : Votre infrastructure est définie dans du code, ce qui la rend facilement reproductible et partageable.
3. **Modularité** : Vous pouvez créer des modules réutilisables pour vos configurations communes.
4. **Prévisibilité** : La commande `terraform plan` vous montre exactement ce qui va être créé, modifié ou supprimé avant d'appliquer les changements.

### Bonnes pratiques pour Terraform

1. **Versionnez votre code** : Utilisez un système de contrôle de version comme Git pour suivre les changements de votre code Terraform.
2. **Utilisez des modules** : Créez des modules réutilisables pour les configurations communes.
3. **Gérez les états à distance** : Utilisez un backend distant comme S3 pour stocker l'état de Terraform, surtout lors du travail en équipe.
4. **Utilisez des workspaces** : Les workspaces Terraform permettent de gérer plusieurs environnements (dev, staging, prod) avec le même code.
5. **Formatez votre code** : Utilisez `terraform fmt` pour maintenir un style de code cohérent.

## Conclusion

Que vous choisissiez d'utiliser l'AWS CLI via Docker ou Terraform, chaque approche a ses avantages. L'AWS CLI offre une flexibilité et un contrôle directs, tandis que Terraform fournit une gestion plus complète de l'infrastructure avec des fonctionnalités avancées de gestion d'état et de planification.

Pour des tâches ponctuelles ou des scripts d'automatisation simples, l'AWS CLI peut être plus approprié. Pour la gestion à long terme d'une infrastructure complexe, Terraform offre des avantages significatifs en termes de maintenabilité et de reproductibilité.

Dans tous les cas, assurez-vous de suivre les bonnes pratiques de sécurité, de versionnage et de documentation pour maintenir une infrastructure cloud robuste et gérable.