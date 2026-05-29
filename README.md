# 🚀 Skeleton Laravel 13 Dockerisé

<p align="center">
  <img src="https://img.shields.io/badge/Laravel-13.x-FF2D20?style=for-the-badge&logo=laravel&logoColor=white" alt="Laravel 13" />
  <img src="https://img.shields.io/badge/PHP-8.5-777BB4?style=for-the-badge&logo=php&logoColor=white" alt="PHP 8.5" />
  <img src="https://img.shields.io/badge/MySQL-8.4-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL 8.4" />
  <img src="https://img.shields.io/badge/Docker-compose-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker Compose" />
</p>

Ce projet est un environnement de développement complet (Skeleton) basé sur **Laravel 13**. Il est entièrement conteneurisé grâce à **Docker** et **Docker Compose** pour une installation rapide, uniforme et sans conflit.

---

## 📋 Table des Matières

- [✨ Fonctionnalités](#-fonctionnalités)
- [🛠 Prérequis](#-prérequis)
- [⚙️ Configuration Initiale](#️-configuration-initiale)
- [🚀 Lancement du Projet](#-lancement-du-projet)
- [📦 Architecture des Conteneurs](#-architecture-des-conteneurs)
- [🗄️ Accès aux Services](#️-accès-aux-services)
- [💡 Commandes Utiles](#-commandes-utiles)

---

## ✨ Fonctionnalités

- **PHP 8.5** avec Apache prêt à l'emploi.
- **Laravel 13** préconfiguré pour communiquer avec la base de données MySQL.
- **MySQL 8.4** avec script d'initialisation automatique via `docker/mysql/init.sql`.
- **phpMyAdmin** intégré pour gérer facilement votre base de données via une interface graphique.
- Architecture modulaire, isolée et simple à déployer.

---

## 🛠 Prérequis

Avant de commencer, assurez-vous de disposer des outils suivants sur votre machine :
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/)

---

## ⚙️ Configuration Initiale

1. **Cloner le dépôt :**
   ```bash
   git clone <URL_DU_DEPOT>
   cd skeleton-laravel
   ```

2. **Configurer l'environnement Docker :**
   Copiez le fichier d'exemple fourni à la racine et renommez-le :
   ```bash
   cp .env.example .env
   ```
   *Ouvrez le fichier `.env` afin de personnaliser les mots de passe de la base de données (`DB_PASSWORD`, `DB_ROOT_PASSWORD`) pour plus de sécurité.*

3. **Configurer l'environnement Laravel :**
   Allez dans le dossier source et configurez le `.env` de Laravel :
   ```bash
   cd src
   cp .env.example .env
   ```
   *(Modifiez l'URL de l'application - `APP_URL` - ou d'autres paramètres spécifiques à Laravel dans ce fichier `src/.env`).*

---

## 🚀 Lancement du Projet

Pour démarrer tous les services en arrière-plan, exécutez la commande suivante à la racine du projet :

```bash
docker compose up -d
```

> ⏳ *Lors de la première exécution, le téléchargement des images, la construction du conteneur applicatif (PHP 8.5 + Apache), l'installation automatique des dépendances via Composer, la génération de la clé Laravel, et l'exécution automatique des migrations de base de données s'exécutent de manière totalement automatisée.*

---

## 📦 Architecture des Conteneurs

L'environnement réseau est orchestré par le fichier `compose.yml` et se compose de 3 services :

| Service | Source/Image | Rôle |
|:---:|:---|:---|
| **`app`** | `./docker/php/Dockerfile` (PHP 8.5) | **Serveur Web & PHP** : Contient PHP 8.5 + Apache et expose l'application basée sur le code de `src/`. |
| **`db`** | `mysql:8.4` | **Base de données** : Serveur MySQL. Les données sont persistantes grâce au volume partagé `db_data`. |
| **`phpmyadmin`**| `phpmyadmin:latest` | **Administration BDD** : Interface web connectée automatiquement au service `db`. |

---

## 🗄️ Accès aux Services

Une fois les conteneurs démarrés, vous pouvez accéder à vos différents services via ces liens :

- 🌐 **Application Laravel :** [http://localhost:8200](http://localhost:8200)
- 📊 **phpMyAdmin :** [http://localhost:8201](http://localhost:8201)
  - *Serveur* : `db` (se connecte via le réseau Docker)
  - *Utilisateur* : `default_user` *(voir `.env`)*
  - *Mot de passe* : `default_password` *(voir `.env`)*

🔌 **Connexion Externe à la base (ex: DBeaver, DataGrip) :** 
- **Hôte :** `127.0.0.1` 
- **Port :** `3308`

> **Note :** Si les ports `8200` ou `8201` sont déjà utilisés sur votre machine hôte, vous pouvez facilement les modifier en ajustant `APP_PORT` et `PHPMYADMIN_PORT` dans le fichier `.env` à la racine.

---

## 💡 Commandes Utiles

**Arrêter les conteneurs (en conservant les données) :**
```bash
docker compose down
```

**Arrêter les conteneurs et détruire les volumes (⚠️ Supprime la BDD) :**
```bash
docker compose down -v
```

**Voir les logs en temps réel (pour le débogage) :**
```bash
docker compose logs -f
```

**Exécuter des commandes Artisan (Laravel) :**
Pour utiliser la CLI Laravel (ex: lancer une migration ou vider le cache), il faut le faire au sein du conteneur `app` :
```bash
docker exec -it laravel_app php artisan migrate
docker exec -it laravel_app php artisan cache:clear
```

**Accéder au terminal du conteneur applicatif :**
```bash
docker exec -it laravel_app /bin/bash
```
