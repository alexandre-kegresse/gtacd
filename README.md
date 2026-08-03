# GTACD - GitHub Action CiCd

## Introduction
Projet d'exploration de l'automatisation CI/CD et de la sécurisation des pipelines de déploiement.

## Job 1 : Création d'une Application Simple et d'un Script de Vérification
* Création du répertoire `app/` avec un fichier `index.html` minimaliste.
* Création d'un script Bash de test `check_app.sh` qui valide la présence de l'application et renvoie un code de sortie approprié (0 ou 1).

### Job 2 : Premier Workflow GitHub Actions (CI)
* Création du répertoire `.github/workflows/` et du fichier `ci_basic.yml`.
* Configuration du déclencheur sur les push vers la branche `main`.
* Job `build-and-test` exécuté sur `ubuntu-latest` avec checkout du code, exécution du script de test et affichage du contenu de `index.html`.

### Job 3 : Gestion des Secrets et des Variables d'Environnement
* Configuration des secrets `FAKE_API_TOKEN` et `ENV_TYPE` dans les paramètres GitHub.
* Mise à jour du workflow pour exposer une variable prédéfinie (`RUNNER_OS`), une variable personnalisée, et les secrets.
* Vérification de la censure automatique des secrets dans les logs par GitHub Actions.
* Simulation d'un échec d'intégration en forçant le script `check_app.sh` à renvoyer `exit 1` pour l'analyse post-incident.