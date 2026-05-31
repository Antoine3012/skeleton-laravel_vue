# 🛠️ Simplification des commandes avec Makefile

## 📖 Utilisation générale

Toutes les commandes doivent être exécutées depuis la racine du projet (où se trouve le fichier `Makefile`). 

Pour afficher l'aide interactive avec la liste complète des commandes :
```bash
make
# ou
make help
```

---

## 🗂️ Liste des commandes disponibles

### 🐳 Gestion de Docker

| Commande | Action réelle sous le capot | Rôle |
| :--- | :--- | :--- |
| `make up` | `docker compose up -d` | Démarre les conteneurs en arrière-plan (detached). |
| `make down` | `docker compose down` | Arrête et supprime les conteneurs et réseaux. |
| `make restart` | `docker compose down && docker compose up -d` | Redémarre proprement tous les conteneurs de la stack. |
| `make logs` | `docker compose logs -f` | Affiche et suit les journaux de logs en temps réel. |
| `make ps` | `docker compose ps` | Liste les conteneurs en cours d'exécution et leurs ports. |
| `make build` | `docker compose build` | Reconstruit les images de conteneurs Docker du projet. |
| `make shell` | `docker exec -it laravel_app bash` | Ouvre un terminal interactif `bash` dans le conteneur principal. |
| `make db-reset` | `docker compose down -v && docker compose up -d` | **Destruction complète** : supprime les volumes BDD et repart de zéro. |

---

### 📦 Dépendances & Initialisation

| Commande | Action réelle sous le capot | Rôle |
| :--- | :--- | :--- |
| `make install` | `docker exec -it laravel_app composer install && npm install` | Installe toutes les dépendances PHP et JavaScript. |
| `make key-generate` | `docker exec -it laravel_app php artisan key:generate` | Génère la clé de sécurité `.env` de Laravel. |

---

### 🗄️ Base de données (Artisan)

| Commande | Action réelle sous le capot | Rôle |
| :--- | :--- | :--- |
| `make migrate` | `docker exec -it laravel_app php artisan migrate` | Exécute les nouvelles migrations SQL. |
| `make migrate-fresh`| `docker exec -it ... php artisan migrate:fresh --seed` | Réinitialise la BDD et lance les migrations avec les données de test (Seeders). |
| `make seed` | `docker exec -it laravel_app php artisan db:seed` | Remplit la base de données avec les seeders. |

---

### 💎 Qualité du code & Formatage

| Commande | Action réelle sous le capot | Rôle |
| :--- | :--- | :--- |
| `make lint` | `docker exec -it laravel_app npm run lint` | Analyse statique et correction des erreurs JS/Vue (ESLint). |
| `make format` | Runs `npm run format` & `php vendor/bin/pint` | Met en forme automatiquement le PHP, le JS, le CSS et le Vue. |
| `make format-check` | Runs `npm run format:check` & `pint --test` | Vérifie si le code respecte les standards (sans le modifier). |
| `make pint` | `docker exec -it laravel_app php vendor/bin/pint` | Formate le code PHP avec Laravel Pint. |
| `make pint-test` | `docker exec -it ... php vendor/bin/pint --test` | Teste le code PHP sans le corriger (idéal pour la CI). |

---

### 🧪 Tests Automatisés

| Commande | Action réelle sous le capot | Rôle |
| :--- | :--- | :--- |
| `make test` | `docker exec -it laravel_app npm run test` | Lance l'ensemble des tests (Vitest + PHPUnit). |
| `make test-php` | `docker exec -it laravel_app php artisan test` | Lance uniquement les tests unitaires et d'intégration backend PHP. |
| `make test-js` | `docker exec -it laravel_app npm run test:unit` | Lance uniquement les tests unitaires frontend (Vitest). |

---

## 💡 Exemple de flux de travail quotidien

1. **Le matin en arrivant** : `make up` pour lancer l'environnement de travail.
2. **Après avoir tiré les modifications (`git pull`)** : `make install` puis `make migrate` pour mettre à jour les dépendances et la base de données.
3. **Avant de commiter du code** : `make format` pour s'assurer que tout le code est parfaitement propre et structuré.
4. **Avant de pousser sa branche (`git push`)** : `make test` pour s'assurer qu'aucune régression n'a été introduite.
5. **Le soir en partant** : `make down` pour éteindre proprement les conteneurs et libérer les ressources système.

---

## 🧭 Navigation

| ⬅️ [Qualité du Code (Étape 8)](8-code-quality.md) | 🏠 [Retour à l'Accueil](../../README.fr.md) |
