# 💎 Qualité du Code & Formatage automatique

## 🛠️ Présentation des Outils

### 1. Backend PHP : Laravel Pint
[Laravel Pint](https://laravel.com/docs/11.x/pint) est un fixateur de style de code PHP minimaliste, conçu pour Laravel. Il s'exécute sur le moteur de PHP-CS-Fixer et force le respect des standards PSR-12 et des conventions de Laravel.
*   **Fichier de configuration** : [`src/pint.json`](../../src/pint.json)
*   **Règles appliquées** : Preset `laravel` avec règles personnalisées pour le nettoyage des imports inutilisés (`no_unused_imports`), le tri alphabétique (`ordered_imports`) et l'harmonisation de la syntaxe des tableaux courts.

### 2. Frontend JS/Vue : ESLint
[ESLint](https://eslint.org/) analyse le code JavaScript et les composants Vue 3 à la recherche d'erreurs potentielles, de variables inutilisées, et force le respect des meilleures pratiques de Vue 3.
*   **Fichier de configuration** : [`src/eslint.config.js`](../../src/eslint.config.js) (Flat Config v9)
*   **Règles appliquées** : Recommandations standard ESLint + recommandations de style officielles de Vue 3 (`flat/recommended`), avec désactivation des règles conflictuelles avec Prettier.

### 3. Frontend Multi-fichiers : Prettier
[Prettier](https://prettier.io/) est un formateur de code strict qui gère automatiquement la mise en page (indentation, retours à la ligne, guillemets) pour les fichiers JS, Vue, CSS, JSON et Markdown.
*   **Fichier de configuration** : [`src/.prettierrc`](../../src/.prettierrc)
*   **Fichier d'exclusion** : [`src/.prettierignore`](../../src/.prettierignore)
*   **Règles appliquées** : Indentation à **4 espaces** (pour correspondre au `.editorconfig` du projet), guillemets simples (`singleQuote`), points-virgules obligatoires (`semi`) et fins de lignes LF (`endOfLine`).

---

## 🚀 Utilisation en Local

Tous les outils peuvent être lancés manuellement, soit **depuis votre machine hôte**, soit **à l'intérieur du conteneur Docker** `laravel_app`.

### Option A : Depuis votre machine hôte (Recommandé si PHP/Node sont installés localement)
Si vous disposez de PHP 8.5+ et Node.js 20+ installés localement, vous pouvez exécuter ces commandes directement à la racine du dossier `src/` :

```bash
cd src

# --- LARAVEL PINT (PHP) ---
# Vérifier le style sans le modifier
./vendor/bin/pint --test
# Corriger automatiquement les fichiers PHP
./vendor/bin/pint

# --- ESLINT & PRETTIER (JS/Vue) ---
# Lancer l'analyse statique et corriger les erreurs corrigibles
npm run lint
# Vérifier le formatage Prettier
npm run format:check
# Formater automatiquement tous les fichiers JS/Vue/CSS/JSON
npm run format
```

### Option B : Depuis le conteneur Docker (Aucun outil requis sur l'hôte)
Si vous n'avez ni PHP ni Node installés localement, vous pouvez exécuter les outils directement via Docker :

```bash
# --- LARAVEL PINT (PHP) ---
# Vérifier le style PHP
docker exec -it laravel_app php vendor/bin/pint --test
# Corriger le style PHP automatiquement
docker exec -it laravel_app php vendor/bin/pint

# --- ESLINT & PRETTIER (JS/Vue) ---
# Lancer l'analyse ESLint dans le conteneur
docker exec -it laravel_app npm run lint
# Vérifier le formatage Prettier dans le conteneur
docker exec -it laravel_app npm run format:check
# Formater automatiquement avec Prettier dans le conteneur
docker exec -it laravel_app npm run format
```

---

## 🚀 Intégration Continue (CI/CD)

Le pipeline GitHub Actions configuré dans [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml) valide systématiquement la qualité du code lors de chaque Push ou Pull Request sur les branches principales (`main`, `master`, `develop`).

Le pipeline échouera immédiatement si :
*   Des fichiers PHP ne respectent pas le style standard (`vendor/bin/pint --test`).
*   Des erreurs de linter ESLint sont détectées (`npm run lint`).
*   Des fichiers JS/Vue/CSS/JSON ne respectent pas le formatage Prettier (`npm run format:check`).

Reportez-vous au guide **[🚀 Intégration Continue (Étape 7)](7-ci-cd.md)** pour savoir comment diagnostiquer et résoudre un échec de build en CI.

---

## 🧭 Navigation

| ⬅️ [Intégration Continue (Étape 7)](7-ci-cd.md) | 🏠 [Retour à l'Accueil](../../README.fr.md) |
