# ⚙️ Installation et Configuration

## 🛠️ Prérequis

Avant de démarrer, assurez-vous d'avoir installé les outils suivants sur votre système :

1.  **Git** : [Git](https://git-scm.com/) pour versionner votre code et cloner le projet.
2.  **Docker** : [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows, macOS et Linux) ou Docker Engine (pour les distributions Linux sans interface graphique).
3.  **Docker Compose** : Inclus par défaut dans Docker Desktop, ou à installer séparément sur Linux.

> [!NOTE]
> Aucun outil local comme PHP, Composer, Node.js ou MySQL n'est requis sur votre machine physique. Tout s'exécute de manière isolée au sein des conteneurs Docker.

---

## 🚀 Étapes d'Installation

### 1. Cloner le Dépôt
Commencez par récupérer le projet depuis votre hébergeur Git :
```bash
git clone <URL_DU_DEPOT>
cd skeleton-laravel_vue
```

---

### 2. Configuration des Variables d'Environnement Docker
À la racine du projet, vous devez copier le fichier `.env.example` en `.env` :
```bash
cp .env.example .env
```
Ce fichier sert à configurer le comportement global de Docker Compose. Vous pouvez y éditer les variables suivantes :
*   `DB_NAME` : Nom de la base de données créée au démarrage.
*   `DB_USER` & `DB_PASSWORD` : Identifiants de connexion MySQL standard.
*   `DB_ROOT_PASSWORD` : Mot de passe administrateur pour MySQL.
*   `APP_PORT` : Le port de votre machine hôte sur lequel sera accessible le site web (par défaut : `8200`).
*   `PHPMYADMIN_PORT` : Le port d'accès à phpMyAdmin (par défaut : `8201`).

---

### 3. Configuration des Variables d'Environnement de Laravel
L'application Laravel située dans le dossier `src` a également besoin de son propre fichier de configuration `.env`. Allez dans ce dossier et copiez le fichier :
```bash
cd src
cp .env.example .env
cd ..
```
> [!IMPORTANT]
> Les valeurs de base de données par défaut de `src/.env` (`DB_HOST=db`, `DB_PORT=3306`, etc.) correspondent exactement aux configurations définies dans le Docker Compose racine. Vous n'avez pas besoin de les modifier pour un fonctionnement standard.
> 
> Si vous changez les identifiants ou le nom de la base de données dans le fichier `.env` racine (étape 2), veillez à reporter **les mêmes modifications** dans `src/.env` (`DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`).

---

### 4. Lancement des Conteneurs
À la racine du projet, lancez l'orchestration des conteneurs en arrière-plan :
```bash
docker compose up -d
```

---

## ⏳ Que se passe-t-il au premier démarrage ?

Lors du tout premier lancement, Docker effectue automatiquement plusieurs opérations complexes grâce au script `docker/php/entrypoint.sh` :

1.  **Téléchargement et Build** : Télécharge les images système nécessaires et construit l'image de l'application (PHP 8.5 + Apache + Node.js).
2.  **Installation des dépendances PHP** : Exécute en interne `composer install` pour installer tous les paquets du framework Laravel.
3.  **Génération de Clé** : Génère automatiquement la clé d'application Laravel (`APP_KEY`) si elle est manquante dans `src/.env`.
4.  **Base de Données** : Attend que le service MySQL soit sain et prêt, puis exécute automatiquement les migrations de base de données (`php artisan migrate --force`).
5.  **Installation des dépendances Node.js** : Détecte l'absence du dossier `node_modules` et exécute automatiquement `npm install` dans le conteneur.
6.  **Compilation Initiale** : Lance la commande `npm run build` pour compiler les scripts Vue.js initiaux et les rendre disponibles via le serveur Apache.

> [!TIP]
> Cette automatisation peut prendre de **1 à 3 minutes** selon votre connexion internet et les performances de votre ordinateur. Vous pouvez suivre l'avancée de cette installation en affichant les logs en temps réel :
> ```bash
> docker compose logs -f app
> ```

---

## 🌐 Liens d'Accès aux Services

Une fois l'installation terminée avec succès, vous pouvez ouvrir votre navigateur aux adresses suivantes :

*   **Application Web (Laravel + Vue)** : [http://localhost:8200](http://localhost:8200)
*   **Administration phpMyAdmin** : [http://localhost:8201](http://localhost:8201)
    *   *Serveur* : `db`
    *   *Utilisateur* : `default_user` (ou la valeur de `DB_USER` du `.env` racine)
    *   *Mot de passe* : `default_password` (ou la valeur de `DB_PASSWORD` du `.env` racine)
*   **Bilan de santé applicatif (Health Check)** : [http://localhost:8200/up](http://localhost:8200/up)

---

## 🏥 Bilans de Santé (Health Checks)

Le projet intègre un système de surveillance à deux niveaux :

### 1. Niveau Applicatif (Laravel)
L'URL `/up` effectue en temps réel plusieurs diagnostics critiques :
*   **Base de Données** : Vérifie la connectivité active avec le conteneur MySQL.
*   **Cache** : Vérifie que le service de stockage temporaire (Cache) accepte les opérations en lecture et écriture.
*   **Système de Fichiers** : Vérifie les permissions d'écriture sur les répertoires système essentiels (`storage/framework/cache`, `storage/logs`).

Si l'un de ces points échoue (par exemple, perte de connexion avec la base de données), l'URL renvoie un statut **HTTP 500** avec un payload JSON `{ "status": "down" }`.

### 2. Niveau Infrastructure (Docker Compose)
Le conteneur `laravel_app` est configuré avec un `healthcheck` périodique. Docker exécute automatiquement en arrière-plan la commande suivante toutes les 30 secondes :
```bash
curl -f http://localhost/up
```
*   Si le conteneur est pleinement fonctionnel, son état passe à `(healthy)`.
*   Vous pouvez consulter cet état à tout moment via la commande `make ps` (ou `docker compose ps`).

---

## ⚙️ Résolution de Conflits de Ports (ex: port déjà utilisé)

Si les ports `8200` ou `8201` sont déjà pris par un autre projet ou service sur votre ordinateur, les conteneurs refuseront de démarrer.

Pour résoudre ce problème :
1.  Ouvrez le fichier `.env` **à la racine** du projet.
2.  Modifiez les valeurs des variables :
    ```ini
    APP_PORT=8500          # Exemple de port alternatif pour l'application
    PHPMYADMIN_PORT=8501   # Exemple de port alternatif pour phpMyAdmin
    ```
3.  Recréez et relancez les conteneurs :
    ```bash
    docker compose up -d
    ```
4.  Votre application sera maintenant disponible sur [http://localhost:8500](http://localhost:8500).

---

## 🧭 Navigation

| ⬅️ [Architecture (Étape 1)](1-architecture.md) | 🏠 [Retour à l'Accueil](../../README.fr.md) | [Développement Frontend (Étape 3) ➡️](3-frontend.md) |
