# 💎 Code Quality & Automatic Formatting

## 🛠️ Overview of the Tools

### 1. PHP Backend: Laravel Pint
[Laravel Pint](https://laravel.com/docs/11.x/pint) is an opinionated, minimalist PHP code style fixer for Laravel. It runs on top of PHP-CS-Fixer and enforces PSR-12 standard compliance and Laravel conventions.
*   **Configuration file**: [`src/pint.json`](../../src/pint.json)
*   **Applied rules**: `laravel` preset with custom rules for unused imports cleanup (`no_unused_imports`), alphabetical sorting (`ordered_imports`), and short array syntax harmonization.

### 2. JS/Vue Frontend: ESLint
[ESLint](https://eslint.org/) analyzes JavaScript code and Vue 3 components to find potential errors, unused variables, and enforce Vue 3 official best practices.
*   **Configuration file**: [`src/eslint.config.js`](../../src/eslint.config.js) (Flat Config v9)
*   **Applied rules**: ESLint standard recommendations + Vue 3 official style recommendations (`flat/recommended`), with formatting rules that conflict with Prettier disabled.

### 3. Multi-file Frontend: Prettier
[Prettier](https://prettier.io/) is an opinionated code formatter that automatically handles layout (indentation, line breaks, quotes) for JS, Vue, CSS, JSON, and Markdown files.
*   **Configuration file**: [`src/.prettierrc`](../../src/.prettierrc)
*   **Exclusion file**: [`src/.prettierignore`](../../src/.prettierignore)
*   **Applied rules**: **4-space** indentation (to match the project's `.editorconfig`), single quotes (`singleQuote`), mandatory semicolons (`semi`), and LF line endings (`endOfLine`).

---

## 🚀 Local Usage

All tools can be run manually, either **from your host machine** or **inside the `laravel_app` Docker container**.

### Option A: From your host machine (Recommended if PHP/Node are installed locally)
If you have PHP 8.5+ and Node.js 20+ installed locally, you can execute these commands directly in the `src/` directory:

```bash
cd src

# --- LARAVEL PINT (PHP) ---
# Verify style without modifying files
./vendor/bin/pint --test
# Automatically fix PHP files
./vendor/bin/pint

# --- ESLINT & PRETTIER (JS/Vue) ---
# Run linting and fix fixable errors
npm run lint
# Verify Prettier formatting
npm run format:check
# Automatically format all JS/Vue/CSS/JSON files
npm run format
```

### Option B: From the Docker container (No tools required on the host)
If you don't have PHP or Node installed locally, you can run the tools directly inside Docker:

```bash
# --- LARAVEL PINT (PHP) ---
# Verify PHP code style
docker exec -it laravel_app php vendor/bin/pint --test
# Automatically fix PHP style
docker exec -it laravel_app php vendor/bin/pint

# --- ESLINT & PRETTIER (JS/Vue) ---
# Run ESLint inside the container
docker exec -it laravel_app npm run lint
# Verify Prettier formatting inside the container
docker exec -it laravel_app npm run format:check
# Automatically format with Prettier inside the container
docker exec -it laravel_app npm run format
```

---

## 🚀 Continuous Integration (CI/CD)

The GitHub Actions pipeline configured in [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml) systematically validates code quality on every Push or Pull Request to the main branches (`main`, `master`, `develop`).

The pipeline will fail immediately if:
*   Any PHP file does not respect the standard style (`vendor/bin/pint --test`).
*   Any ESLint linter error is detected (`npm run lint`).
*   Any JS/Vue/CSS/JSON file does not respect the Prettier formatting (`npm run format:check`).

Refer to the **[🚀 Continuous Integration (Step 7)](7-ci-cd.md)** guide to learn how to diagnose and resolve CI build failures.

---

## 🧭 Navigation

| ⬅️ [Continuous Integration (Step 7)](7-ci-cd.md) | 🏠 [Back to Home](../../README.md) |
