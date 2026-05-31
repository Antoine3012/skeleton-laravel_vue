# 🚀 Skeleton Laravel 13 & Vue 3 Dockerisé

<p align="center">
  🌎 Lire ce document en : 🇬🇧 <b><a href="README.md">English</a></b> | 🇫🇷 <b>Français</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Laravel-13.x-FF2D20?style=for-the-badge&logo=laravel&logoColor=white" alt="Laravel 13" />
  <img src="https://img.shields.io/badge/Vue.js-3.x-4FC08D?style=for-the-badge&logo=vue.js&logoColor=white" alt="Vue 3" />
  <img src="https://img.shields.io/badge/Inertia.js-2.0-9553E9?style=for-the-badge&logo=inertia&logoColor=white" alt="Inertia.js" />
  <img src="https://img.shields.io/badge/PHP-8.5-777BB4?style=for-the-badge&logo=php&logoColor=white" alt="PHP 8.5" />
  <img src="https://img.shields.io/badge/MySQL-8.4-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL 8.4" />
  <img src="https://img.shields.io/badge/Docker-compose-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker Compose" />
</p>

Projet de développement complet (Skeleton) basé sur **Laravel 13** et **Vue.js 3** connectés via **Inertia.js**. Il est entièrement conteneurisé grâce à **Docker** et **Docker Compose** pour une installation et un développement local uniformes, sans conflit et ultra-rapides.

---

## 📖 Guide de Documentation Modulaire

Pour faciliter la prise en main, la documentation a été découpée en guides thématiques clairs :

1.  **[🏗️ Architecture du Projet](docs/fr/1-architecture.md)**
    *   Stack technique globale.
    *   Visualiser le flux des requêtes avec le pont **Inertia.js**.
    *   Arborescence des dossiers (`docker/` vs `src/`).
2.  **[⚙️ Guide d'Installation et Configuration](docs/fr/2-installation.md)**
    *   Cloner et lancer le projet.
    *   Configuration des fichiers d'environnement `.env`.
    *   Gestion et personnalisation des ports hôtes.
3.  **[🎨 Guide de Développement Frontend](docs/fr/3-frontend.md)**
    *   Création de pages avec **Vue 3 (Script Setup)**.
    *   Fonctionnement de **Vite** et du **Hot Module Replacement (HMR)** sous Docker.
    *   Intégration de **Tailwind CSS** et aliases d'import.
4.  **[🗄️ Gestion de la Base de Données](docs/fr/4-database.md)**
    *   Initialisation et base de tests.
    *   Lancement automatique et manuel des migrations et seeders.
    *   Accès à l'interface **phpMyAdmin** et configuration de clients externes (DBeaver, DataGrip).
5.  **[🐳 Docker & Troubleshooting](docs/fr/5-docker-troubleshooting.md)**
    *   Commandes Docker indispensables (`logs`, `build`, `down -v`).
    *   Exécution de scripts Artisan, Composer et NPM dans les conteneurs.
    *   Résolutions de pannes (permissions de fichiers, réinstallations propres, conflits).
6.  **[🧪 Tests Automatisés](docs/fr/6-tests.md)**
    *   Structure unifiée (PHPUnit pour PHP et Vitest pour Vue 3).
    *   Commandes pour exécuter tous les tests ou des cibles spécifiques.
    *   Écriture de nouveaux tests unitaires backend et frontend.
7.  **[🚀 Intégration Continue (CI/CD)](docs/fr/7-ci-cd.md)**
    *   Pipeline automatisé avec **GitHub Actions**.
    *   Linting, tests et validation du build de production à chaque Pull Request.
    *   Résolution des pannes courantes en CI (style Pint, dépendances Ziggy).
8.  **[💎 Qualité de Code & Formateurs](docs/fr/8-code-quality.md)**
    *   Standards backend PHP avec **Laravel Pint**.
    *   Qualité et style frontend avec **ESLint** et **Prettier**.
9.  **[🛠️ Simplification des Commandes (Makefile)](docs/fr/9-makefile.md)**
    *   Point d'entrée unique pour la stack Docker/Laravel/Vue.

---

## 🛠️ Prérequis & ⚡ Quickstart

Pour exécuter ce projet, vous devez installer **[Docker](https://www.docker.com/get-started/)** (qui inclut Docker Compose) et **[Git](https://git-scm.com/)** sur votre machine. Aucun autre outil local (PHP, Composer, Node.js ou MySQL) n'est requis.

### Démarrage rapide (si vous avez déjà Docker et Git) :

### 1. Cloner et configurer les environnements
```bash
git clone <URL_DU_DEPOT>
cd skeleton-laravel_vue

# Configurer l'environnement Docker racine
cp .env.example .env

# Configurer l'environnement Laravel
cd src && cp .env.example .env && cd ..
```

### 2. Démarrer les conteneurs
```bash
docker compose up -d
```
> ⏳ *Lors du premier démarrage, Docker installe automatiquement toutes vos dépendances (Composer et NPM), génère votre clé Laravel, exécute les migrations SQL et compile vos assets frontend. Cela prend entre 1 et 3 minutes.*

### 3. Accéder aux services
*   🌐 **Application Web (Laravel + Vue)** : [http://localhost:8200](http://localhost:8200)
*   📊 **phpMyAdmin (Gestion BDD)** : [http://localhost:8201](http://localhost:8201) (Serveur: `db`)

---

## 📦 Architecture des Services Docker

L'infrastructure réseau orchestrée par le fichier `compose.yml` se compose de 3 services principaux isolés :

| Service | Image / Source | Rôle | Accès Interne | Accès Externe (Hôte) |
| :---: | :--- | :--- | :---: | :---: |
| **`app`** | `./docker/php/Dockerfile` (PHP 8.5) | **Serveur Web & PHP** : Contient PHP 8.5 + Apache + Node.js et expose l'application basée sur le code de `src/`. | `Port 80` | `http://localhost:8200` |
| **`db`** | `mysql:8.4` | **Base de données** : Serveur MySQL. Données persistantes via le volume `db_data`. | `Port 3306` | `127.0.0.1:3308` |
| **`phpmyadmin`**| `phpmyadmin:latest` | **Administration BDD** : Interface web connectée automatiquement au service `db`. | `Port 80` | `http://localhost:8201` |

---

## 💡 Commandes Utiles (Simplifiées via Makefile)

Grâce au **[Makefile (Étape 9)](docs/fr/9-makefile.md)**, toutes vos commandes quotidiennes sont simplifiées :

*   **Afficher l'aide interactive** : `make` (ou `make help`)
*   **Démarrer la stack Docker** : `make up`
*   **Arrêter les conteneurs proprement** : `make down`
*   **Voir l'activité et déboguer (logs)** : `make logs`
*   **Lancer tous les tests (PHPUnit + Vitest)** : `make test`
*   **Lancer les formateurs et linters** : `make format`
*   **Exécuter les migrations de base de données** : `make migrate`
*   **Réinitialiser complètement la base de données** : `make db-reset`
