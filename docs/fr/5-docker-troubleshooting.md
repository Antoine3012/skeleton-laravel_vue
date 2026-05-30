# 🐳 Docker & Dépannage (Troubleshooting)

## 🛠️ Commandes Docker Compose Indispensables

Toutes ces commandes doivent être exécutées depuis la racine du projet (là où se situe le fichier `compose.yml`).

### 1. Cycle de vie des conteneurs
*   **Démarrer l'environnement (en tâche de fond) :**
    ```bash
    docker compose up -d
    ```
*   **Arrêter tous les conteneurs (sans perte de données) :**
    ```bash
    docker compose down
    ```
*   **Arrêter et détruire toutes les données (⚠️ Supprime la Base de Données) :**
    ```bash
    docker compose down -v
    ```
    *(Utile pour forcer la réinitialisation complète de MySQL et réexécuter le script `init.sql`).*

### 2. Monitoring et Logs
*   **Vérifier le statut des conteneurs :**
    ```bash
    docker compose ps
    ```
*   **Voir tous les logs en temps réel :**
    ```bash
    docker compose logs -f
    ```
*   **Voir uniquement les logs du serveur Web/PHP :**
    ```bash
    docker compose logs -f app
    ```
*   **Voir uniquement les logs de la base de données :**
    ```bash
    docker compose logs -f db
    ```

---

## 💻 Exécution de Commandes dans le Conteneur Applicatif

Pour éviter les divergences de version de PHP ou Node entre votre système local et le serveur, utilisez toujours `docker exec` pour lancer des commandes au sein du conteneur `laravel_app`.

### Raccourcis rapides
*   **Accéder au Terminal du conteneur (Bash) :**
    ```bash
    docker exec -it laravel_app /bin/bash
    ```
*   **Commandes Laravel (Artisan) :**
    ```bash
    docker exec -it laravel_app php artisan <commande>
    ```
*   **Commandes Composer :**
    ```bash
    docker exec -it laravel_app composer <commande>
    ```
*   **Commandes NPM / Node :**
    ```bash
    docker exec -it laravel_app npm <commande>
    ```

---

## 🔍 Résolution des Problèmes Courants (FAQ)

### 1. Conflit de ports au lancement (`port is already allocated`)
*   **Symptôme** : Au moment du `docker compose up -d`, un message d'erreur indique qu'un port est déjà utilisé sur votre machine.
*   **Cause** : Un autre serveur local (ex: XAMPP, WampServer, un autre conteneur Docker ou un serveur MySQL local) occupe déjà les ports `8200`, `8201` ou `3308`.
*   **Solution** : 
    1.  Ouvrez le fichier `.env` situé à la racine du projet.
    2.  Modifiez les variables `APP_PORT` ou `PHPMYADMIN_PORT` (ex: mettez `8500` et `8501`).
    3.  Modifiez le port externe MySQL dans le fichier `compose.yml` si le port `3308` est pris :
        ```yaml
        ports:
          - "3309:3306" # Remplacez 3308 par 3309
        ```
    4.  Relancez : `docker compose up -d`.

---

### 2. Problème de permissions de fichiers (Linux/macOS)
*   **Symptôme** : Erreur Laravel `The stream or file "/var/www/html/storage/logs/laravel.log" could not be opened: permission denied`.
*   **Cause** : Sur les systèmes Unix (Linux, macOS), les identifiants d'utilisateur (UID) entre votre machine hôte et le conteneur (`www-data`) peuvent différer, empêchant Laravel d'écrire dans les dossiers `storage/` ou `bootstrap/cache/`.
*   **Solution** : 
    Attribuez la propriété du dossier au serveur web à l'intérieur du conteneur :
    ```bash
    docker exec -it laravel_app chown -R www-data:www-data storage bootstrap/cache
    ```
    Ou donnez les permissions d'écriture maximales (en local uniquement) :
    ```bash
    docker exec -it laravel_app chmod -R 777 storage bootstrap/cache
    ```

---

### 3. Dépendances corrompues ou incomplètes (Composer/NPM)
*   **Symptôme** : Des erreurs de classes PHP manquantes ou des erreurs de compilation Javascript bizarres se produisent.
*   **Cause** : Une installation partielle ou interrompue a corrompu les répertoires `vendor/` ou `node_modules/`.
*   **Solution** : 
    1.  Supprimez physiquement les répertoires locaux `src/vendor` et `src/node_modules`.
    2.  Arrêtez et redémarrez les conteneurs :
        ```bash
        docker compose down
        docker compose up -d
        ```
    3.  Le script `entrypoint.sh` détectera l'absence des dossiers et réinstallera proprement toutes les dépendances PHP et JS au démarrage.

---

### 4. Forcer la reconstruction complète des images
*   **Symptôme** : Vous avez modifié le `Dockerfile` ou le fichier de configuration Apache et vos changements ne s'appliquent pas.
*   **Solution** : 
    Forcez Docker à ignorer le cache et à reconstruire l'image applicative :
    ```bash
    docker compose build --no-cache
    docker compose up -d
    ```

---

## 🧭 Navigation

| ⬅️ [Base de Données (Étape 4)](4-database.md) | 🏠 [Retour à l'Accueil](../../README.fr.md) |
