# 🗄️ Gestion de la Base de Données

## ⚙️ Configuration Globale

Le service MySQL est défini dans le fichier `compose.yml` de la manière suivante :

*   **Image** : `mysql:8.4`
*   **Port Interne** : `3306` (utilisé par le conteneur `app` de Laravel).
*   **Port Externe** : `3308` (exposé pour votre machine hôte).
*   **Volume persistant** : `db_data` (évite de perdre vos tables et données lorsque vous éteignez Docker).

Les variables de connexion sont définies dans le fichier `.env` racine (et synchronisées dans `src/.env`).

---

## 🧪 Base de Données de Test et Initialisation SQL

Au démarrage du conteneur MySQL, le script `docker/mysql/init.sql` est automatiquement exécuté :
```sql
CREATE DATABASE IF NOT EXISTS `default_test_db`;
GRANT ALL PRIVILEGES ON `default_test_db`.* TO 'default_user'@'%';
FLUSH PRIVILEGES;
```
Ce script crée une base de données de test isolée appelée `default_test_db` afin que vous puissiez exécuter vos tests unitaires et d'intégration Laravel sans altérer votre base de développement principale.

---

## 🚀 Migrations et Seeders

### 1. Exécution automatique
À chaque lancement de `docker compose up -d`, le script d'entrée de notre conteneur applicatif exécute automatiquement :
```bash
php artisan migrate --force
```
Cela garantit que votre schéma de base de données est toujours à jour avec le code le plus récent disponible dans votre dépôt.

### 2. Exécution manuelle de commandes SQL / Artisan
Toutes les commandes de base de données doivent être lancées au sein du conteneur applicatif `laravel_app` pour que PHP ait accès au réseau interne de Docker :

*   **Créer une nouvelle migration :**
    ```bash
    docker exec -it laravel_app php artisan make:migration create_posts_table
    ```
*   **Lancer les migrations manuellement :**
    ```bash
    docker exec -it laravel_app php artisan migrate
    ```
*   **Revenir en arrière (Rollback) :**
    ```bash
    docker exec -it laravel_app php artisan migrate:rollback
    ```
*   **Réinitialiser complètement la base de données :**
    ```bash
    docker exec -it laravel_app php artisan migrate:fresh
    ```
*   **Remplir la base de données avec des fausses données (Seeding) :**
    ```bash
    docker exec -it laravel_app php artisan db:seed
    ```

---

## 🌐 Connexion à phpMyAdmin (Interface Web)

Pour administrer votre base de données facilement depuis votre navigateur :
1.  Rendez-vous sur **[http://localhost:8201](http://localhost:8201)**.
2.  Remplissez le formulaire de connexion avec les informations du fichier `.env` racine :
    *   **Serveur** : `db` (très important : n'utilisez pas `localhost` ou `127.0.0.1` ici, car phpMyAdmin s'exécute dans un conteneur et doit cibler le nom du conteneur MySQL de Docker).
    *   **Utilisateur** : `default_user` *(voir `.env` racine)*.
    *   **Mot de passe** : `default_password` *(voir `.env` racine)*.

---

## 🔌 Connexion depuis un Client Externe (DBeaver, DataGrip, TablePlus...)

Si vous préférez utiliser un client SQL lourd installé sur votre machine hôte pour travailler :

1.  Créez une nouvelle connexion **MySQL** dans votre outil.
2.  Renseignez les paramètres suivants :
    *   **Hôte** (Host) : `127.0.0.1` ou `localhost`
    *   **Port** : `3308` (qui fait le pont vers le port `3306` interne du conteneur).
    *   **Base de données** (Database) : `default_db` *(ou la valeur de `DB_NAME` dans le `.env` racine)*.
    *   **Utilisateur** (Username) : `default_user` *(ou la valeur de `DB_USER` dans le `.env` racine)*.
    *   **Mot de passe** (Password) : `default_password` *(ou la valeur de `DB_PASSWORD` dans le `.env` racine)*.

> [!TIP]
> Si la connexion échoue, vérifiez que le conteneur `laravel_db` est bien démarré et sain en lançant la commande `docker ps`.

---

## ➡️ Étape Suivante
Pour connaître les commandes Docker indispensables et résoudre les pannes courantes (problèmes de permissions, réinitialisation de BDD, etc.), lisez le **[Guide Docker & Dépannage (docs/5-docker-troubleshooting.md)](5-docker-troubleshooting.md)**.
