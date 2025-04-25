---
title: "Les bonnes pratiques AWS CLI : Créer une EC2 avec Docker"
date: 2023-06-13
draft: false
tags: ["AWS", "CLI", "Docker", "EC2"]
categories: ["Cloud Computing"]
---

# Les bonnes pratiques AWS CLI : Créer une EC2 avec Docker

L'AWS Command Line Interface (CLI) est un outil puissant pour gérer vos ressources AWS. Cependant, son installation et sa configuration peuvent parfois être fastidieuses. Dans ce post, nous allons explorer une approche élégante pour utiliser l'AWS CLI : l'utilisation d'un conteneur Docker. Nous verrons comment cette méthode peut simplifier votre workflow et améliorer la portabilité de vos scripts AWS.

## Pourquoi utiliser Docker pour l'AWS CLI ?

1. **Portabilité** : Un conteneur Docker peut être exécuté sur n'importe quel système supportant Docker, indépendamment du système d'exploitation.
2. **Isolation** : Les dépendances de l'AWS CLI sont isolées du reste de votre système.
3. **Versioning** : Vous pouvez facilement switcher entre différentes versions de l'AWS CLI.
4. **Reproductibilité** : Votre environnement AWS CLI sera toujours le même, peu importe où vous l'exécutez.

## Prérequis

- Docker installé sur votre machine
- Des credentials AWS valides

## Étape 1 : Préparer vos credentials AWS

Avant de commencer, assurez-vous d'avoir vos credentials AWS à portée de main. Vous aurez besoin de votre AWS Access Key ID et votre AWS Secret Access Key.

## Étape 2 : Créer un fichier Docker

Créez un fichier nommé `Dockerfile` avec le contenu suivant :

```Dockerfile
FROM amazon/aws-cli

WORKDIR /aws

ENTRYPOINT ["aws"]
```

Ce Dockerfile utilise l'image officielle AWS CLI comme base et définit le point d'entrée comme la commande `aws`.

## Étape 3 : Construire l'image Docker

Dans le répertoire contenant votre Dockerfile, exécutez :

```bash
docker build -t my-aws-cli .
```

## Étape 4 : Exécuter le conteneur AWS CLI

Maintenant, vous pouvez exécuter des commandes AWS CLI en utilisant votre conteneur. Voici comment créer une instance EC2 :

```bash
docker run -it --rm \
  -e AWS_ACCESS_KEY_ID=<votre-access-key> \
  -e AWS_SECRET_ACCESS_KEY=<votre-secret-key> \
  -e AWS_DEFAULT_REGION=us-west-2 \
  my-aws-cli ec2 run-instances \
    --image-id ami-0c55b159cbfafe1f0 \
    --instance-type t2.micro \
    --key-name <votre-key-pair> \
    --security-group-ids <votre-security-group> \
    --subnet-id <votre-subnet-id>
```

Assurez-vous de remplacer les valeurs entre `<>` par vos propres valeurs.

## Bonnes pratiques

1. **Sécurité des credentials** : Ne stockez jamais vos credentials AWS dans votre Dockerfile ou dans vos images Docker. Utilisez toujours des variables d'environnement ou des volumes montés pour les fournir au moment de l'exécution.

2. **Utilisation d'alias** : Pour simplifier l'utilisation, vous pouvez créer un alias dans votre shell :

   ```bash
   alias aws='docker run -it --rm -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION my-aws-cli'
   ```

   Ainsi, vous pouvez utiliser `aws` comme si c'était installé localement.

3. **Gestion des versions** : Spécifiez toujours une version spécifique de l'image AWS CLI dans votre Dockerfile pour assurer la reproductibilité.

4. **Utilisation de scripts** : Pour des opérations complexes, écrivez des scripts shell et montez-les dans votre conteneur :

   ```bash
   docker run -it --rm \
     -v $(pwd):/aws \
     -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION \
     my-aws-cli /aws/mon-script.sh
   ```

5. **Nettoyage** : Utilisez toujours l'option `--rm` pour supprimer le conteneur après son exécution, évitant ainsi l'accumulation de conteneurs inutilisés.

## Conclusion

L'utilisation de Docker pour exécuter l'AWS CLI offre une flexibilité et une portabilité accrues. Cette approche vous permet de standardiser votre environnement AWS CLI à travers différentes machines et équipes, tout en maintenant un niveau élevé de sécurité et de reproductibilité. En suivant ces bonnes pratiques, vous pouvez tirer le meilleur parti de l'AWS CLI dans vos workflows DevOps.