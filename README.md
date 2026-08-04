# Runtrack GTACD — Cybersécurité et CI/CD[cite: 1]

Automatisation des processus de livraison logicielle et intégration de mécanismes de sécurité (DevSecOps) avec **GitHub Actions** et **Ansible**[cite: 1]. L'objectif est de comprendre comment sécuriser les pipelines CI/CD pour prévenir les attaques sur les chaînes d'approvisionnement logicielles[cite: 1].

## Environnement de TP

Lab hybride exploitant les services cloud GitHub et une machine virtuelle locale[cite: 1] :

| Environnement | Rôle | OS / Runner |
|---|---|---|
| `GitHub Actions` | Runner CI/CD (Contrôleur) | `ubuntu-latest`[cite: 1] |
| `Serveur Cible` | Cible de Déploiement (CD) | Debian (VM locale)[cite: 1] |

## Structure du projet

~~~text
gtacd/
├── .github/
│   └── workflows/
│       ├── ci_basic.yml                 # Workflow CI : Build & Test
│       └── secure-deployment-simulation.yml # Workflow de validation de sécurité
├── app/
│   ├── index.html                       # Application web minimale
│   └── check_app.sh                     # Script Bash de test local/CI
└── README.md
~~~

---

## Job 1 — Création d'une Application Simple et Script de Vérification[cite: 1]

### 1. Développement de l'application[cite: 1]

~~~bash
mkdir app
# Création du fichier avec un contenu HTML basique
notepad app/index.html
~~~

### 2. Script de test simulé[cite: 1]

~~~bash
# Création du script de vérification
notepad app/check_app.sh
~~~
Le script valide la présence de `app/index.html`[cite: 1]. Il renvoie un code de sortie `0` en cas de succès et `1` en cas d'échec, ce qui servira de première ligne de défense dans le pipeline[cite: 1].

### 3. Configuration des permissions et Push initial[cite: 1]

Sous Windows, il est nécessaire de forcer les droits d'exécution via Git pour que le runner Linux puisse exécuter le script[cite: 1] :

~~~bash
git add app/check_app.sh
git update-index --chmod=+x app/check_app.sh
git commit -m "feat(job1): init app web et script bash"
git push -u origin main
~~~

---

## Job 2 — Premier Workflow GitHub Actions (CI)[cite: 1]

### 1. Création du Workflow[cite: 1]

~~~bash
mkdir .github\workflows
notepad .github\workflows\ci_basic.yml
~~~

### 2. Configuration du CI[cite: 1]

Le fichier `.yml` définit un déclencheur automatique sur chaque `push` de la branche `main`[cite: 1]. Le job `build-and-test` exécute les actions suivantes sur un runner `ubuntu-latest`[cite: 1] :
- Clonage du dépôt via `actions/checkout@v4`[cite: 1].
- Exécution du script de vérification `./app/check_app.sh`[cite: 1].
- Affichage du contenu de `index.html` dans les logs[cite: 1].

~~~bash
git add .
git commit -m "feat(job2): ajout workflow CI"
git push
~~~
*Validation : Le workflow s'exécute avec succès dans l'onglet "Actions" du dépôt.*

---

## Job 3 — Gestion des Secrets et Variables d'Environnement[cite: 1]

### 1. Déclaration des Secrets (Interface GitHub)[cite: 1]

Pour éviter les fuites de données, les credentials ne sont pas versionnés[cite: 1]. Dans **Settings > Secrets and variables > Actions**, ajout de :
- `FAKE_API_TOKEN` (Secret)[cite: 1]
- `ENV_TYPE` avec la valeur `DEV` (Variable)[cite: 1]

### 2. Intégration dans le workflow[cite: 1]

Ajout d'une étape (step) dans `ci_basic.yml` exposant une variable prédéfinie (`RUNNER_OS`) et les secrets[cite: 1]. Lors de l'exécution, GitHub censure automatiquement la valeur des secrets dans les logs (remplacés par `***`)[cite: 1].

### 3. Simulation d'incident et Analyse[cite: 1]

Modification de `app/check_app.sh` pour renvoyer un échec intentionnel (`exit 1`)[cite: 1].

~~~bash
git commit -am "test(job3): simulation echec controle"
git push
~~~
*Analyse post-incident* : Le workflow échoue[cite: 1]. Lecture des logs de l'erreur, puis restauration du code (`exit 0`) pour garantir le bon fonctionnement des étapes suivantes[cite: 1].

---

## Job 4 — Serveur de Déploiement Sécurisé avec Simulation[cite: 1]

### 1. Configuration de la VM cible (Moindre privilège)[cite: 1]

Sur la VM Debian, création d'un utilisateur dédié sans droits root globaux[cite: 1] :
~~~bash
sudo adduser deployuser
# Configuration de sudoers pour autoriser l'exécution de commandes spécifiques sans mot de passe
~~~

### 2. Authentification SSH sécurisée[cite: 1]

Génération d'une paire de clés SSH spécifiquement pour l'automatisation, sans phrase secrète, avec une taille de 2048 bits minimum[cite: 1] :
~~~bash
ssh-keygen -t rsa -b 2048 -f github_deploy_key -N ""
~~~
La clé publique est copiée dans le `/home/deployuser/.ssh/authorized_keys` sur la VM[cite: 1]. L'accès direct via l'utilisateur root est proscrit[cite: 1].

### 3. Secrets de déploiement GitHub[cite: 1]

Ajout des variables de connexion dans les secrets GitHub Actions[cite: 1] :
- `SSH_PRIVATE_KEY` (Contenu de la clé RSA privée)[cite: 1]
- `SERVER_IP` (Adresse IP de la VM)[cite: 1]
- `SERVER_USER` (`deployuser`)[cite: 1]

### 4. Workflow de validation (Simulation)[cite: 1]

Création du workflow `.github/workflows/secure-deployment-simulation.yml` déclenché sur les push et pull requests vers `main`[cite: 1]. Ce workflow n'effectue pas de connexion réseau, mais valide la robustesse de la configuration[cite: 1] :
- Validation de la clé SSH (Vérification de la taille et de l'absence de passphrase)[cite: 1].
- Vérification de la définition de tous les secrets serveur (`SERVER_IP`, `SERVER_USER`)[cite: 1].
- Simulation de la connexion SSH en affichant les commandes de déploiement qui seraient exécutées[cite: 1].