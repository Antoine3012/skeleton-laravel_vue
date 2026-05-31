# 🚀 Intégration Continue (CI/CD)

## 🏗️ Architecture du Pipeline

Pour résoudre les dépendances croisées (comme la compilation de Ziggy qui dépend du répertoire backend), le pipeline s'exécute de manière **séquentielle** dans un job unique sur un environnement `ubuntu-latest` :

```mermaid
graph TD
    Checkout[1. Récupération du Code] --> SetupPHP[2. Setup PHP 8.5 & Extensions]
    SetupPHP --> Composer[3. composer install]
    Composer --> SetupNode[4. Setup Node.js 20]
    SetupNode --> Vitest[5. npm run test:unit]
    Vitest --> ViteBuild[6. npm run build]
    ViteBuild --> Pint[7. vendor/bin/pint --test]
    Pint --> PHPUnit[8. php artisan test]
```

---

## 🛠️ Étapes Détaillées du Workflow

Le workflow est configuré dans le fichier [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml) :

### 1. Initialisation Backend PHP
- **Version** : PHP 8.5 (avec extensions requises : `sqlite`, `pdo_sqlite`, `mbstring`, `zip`, etc.).
- **Mise en cache** : Les dépendances Composer sont mises en cache pour accélérer les exécutions futures.
- **Dépendances** : Lancement de `composer install --prefer-dist --no-progress`.
- **Génération de clé** : Initialisation automatique de la clé applicative via `php artisan key:generate`.

### 2. Initialisation & Build Frontend (Node.js)
- **Version** : Node.js 20 avec mise en cache npm.
- **Dépendances** : Installation stricte via `npm ci`.
- **Tests unitaires (Vitest)** : Exécution de `npm run test:unit` avec la variable d'environnement `LARAVEL_BYPASS_ENV_CHECK: 1` pour éviter le blocage de sécurité en CI.
- **Build de Production** : Compilation des assets via `npm run build`. Cette étape génère le fichier `manifest.json` requis par Inertia.js.

### 3. Contrôle Qualité & Tests Backend
- **Formatage PHP (Laravel Pint)** : Exécution de `vendor/bin/pint --test`. Ce linter vérifie que les règles de style de code (PSR-12/Laravel) sont respectées.
- **Tests Laravel (PHPUnit)** : Lancement de `php artisan test`. Les tests s'exécutent en mémoire SQLite (`:memory:`) pour des performances maximales.

---

## 💡 Résoudre les échecs courants en CI

### 1. Échec de style de code (Laravel Pint)
Si le pipeline échoue à l'étape `Laravel Pint`, cela signifie que des fichiers PHP ne respectent pas le formatage standard.
*   **Correction automatique** : Depuis votre machine (ou dans votre conteneur Docker), exécutez la commande suivante pour corriger automatiquement tous les fichiers :
    ```bash
    docker exec -it laravel_app php vendor/bin/pint
    ```
*   Puis, commitez et poussez les corrections.

### 2. Erreur d'import manquant en production
Si le build échoue à cause d'un import de fichier PHP manquant dans votre code JS (ex: Ziggy), assurez-vous que `composer install` est bien exécuté avant d'appeler Vite.

---

## 🧭 Navigation

| ⬅️ [Tests Automatisés (Étape 6)](6-tests.md) | 🏠 [Retour à l'Accueil](../../README.fr.md) |
