# 🚀 Skeleton Laravel 13 & Vue 3 Containerized

<p align="center">
  🌎 Read this in: 🇬🇧 <b>English</b> | 🇫🇷 <b><a href="README.fr.md">Français</a></b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Laravel-13.x-FF2D20?style=for-the-badge&logo=laravel&logoColor=white" alt="Laravel 13" />
  <img src="https://img.shields.io/badge/Vue.js-3.x-4FC08D?style=for-the-badge&logo=vue.js&logoColor=white" alt="Vue 3" />
  <img src="https://img.shields.io/badge/Inertia.js-2.0-9553E9?style=for-the-badge&logo=inertia&logoColor=white" alt="Inertia.js" />
  <img src="https://img.shields.io/badge/PHP-8.5-777BB4?style=for-the-badge&logo=php&logoColor=white" alt="PHP 8.5" />
  <img src="https://img.shields.io/badge/MySQL-8.4-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL 8.4" />
  <img src="https://img.shields.io/badge/Docker-compose-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker Compose" />
</p>

A complete development project (Skeleton) based on **Laravel 13** and **Vue.js 3** connected via **Inertia.js**. It is fully containerized using **Docker** and **Docker Compose** for seamless, conflict-free, and rapid local development.

---

## 📖 Modular Documentation Guide

To help you get started quickly, the documentation is divided into dedicated guides:

1.  **[🏗️ Project Architecture](docs/en/1-architecture.md)**
    *   Global technology stack.
    *   Visualize request workflow through the **Inertia.js** bridge.
    *   Folder layout tree (`docker/` vs `src/`).
2.  **[⚙️ Installation and Configuration Guide](docs/en/2-installation.md)**
    *   Cloning and starting the project.
    *   Configuring environment variables (`.env` files).
    *   Handling and customizing host port bindings.
3.  **[🎨 Frontend Development Guide](docs/en/3-frontend.md)**
    *   Creating views using **Vue 3 (Script Setup)**.
    *   Understanding **Vite** and **Hot Module Replacement (HMR)** under Docker.
    *   Tailwind CSS integration and path aliasing.
4.  **[🗄️ Database Management](docs/en/4-database.md)**
    *   Global setup and isolated test database.
    *   Running automatic and manual migrations and database seeders.
    *   Accessing **phpMyAdmin** and connecting external SQL clients (DBeaver, DataGrip).
5.  **[🐳 Docker & Troubleshooting](docs/en/5-docker-troubleshooting.md)**
    *   Essential Docker Compose operations (`logs`, `build`, `down -v`).
    *   Executing Artisan, Composer, and NPM commands inside containers.
    *   Troubleshooting port conflicts, Unix file permissions, and package corruptions.
6.  **[🧪 Automated Testing](docs/en/6-tests.md)**
    *   Unified test structure (PHPUnit for PHP and Vitest for Vue 3).
    *   Commands to run all tests or specific targets.
    *   Writing new frontend and backend unit tests.
7.  **[🚀 Continuous Integration (CI/CD)](docs/en/7-ci-cd.md)**
    *   Automated pipeline powered by **GitHub Actions**.
    *   Linting, testing, and production build checks on every Pull Request.
    *   Resolving common CI errors (Pint style, Ziggy imports).
8.  **[💎 Code Quality & Formatters](docs/en/8-code-quality.md)**
    *   PHP backend standards with **Laravel Pint**.
    *   Frontend style and quality using **ESLint** and **Prettier**.

---

## 🛠️ Prerequisites & ⚡ Quickstart

To run this project, you must install **[Docker](https://www.docker.com/get-started/)** (which includes Docker Compose) and **[Git](https://git-scm.com/)** on your system. No other local tools (PHP, Composer, Node.js, or MySQL) are required.

### Quick Start (if you already have Docker and Git):

### 1. Clone the project and configure environment files
```bash
git clone <REPOSITORY_URL>
cd skeleton-laravel_vue

# Configure root Docker environment
cp .env.example .env

# Configure Laravel environment
cd src && cp .env.example .env && cd ..
```

### 2. Boot the containers
```bash
docker compose up -d
```
> ⏳ *During the first startup, Docker automatically downloads container images, installs PHP dependencies (Composer) and Javascript dependencies (NPM), generates the Laravel app key, runs SQL migrations, and compiles frontend assets. This takes between 1 and 3 minutes.*

### 3. Access the services
*   🌐 **Web Application (Laravel + Vue)**: [http://localhost:8200](http://localhost:8200)
*   📊 **phpMyAdmin (Database GUI)**: [http://localhost:8201](http://localhost:8201) (Server: `db`)

---

## 📦 Docker Services Architecture

The network infrastructure orchestrated by the `compose.yml` file consists of 3 isolated main services:

| Service | Image / Source | Role | Internal Port | External Port (Host) |
| :---: | :--- | :--- | :---: | :---: |
| **`app`** | `./docker/php/Dockerfile` (PHP 8.5) | **Web & PHP Server**: Apache + PHP 8.5 + Node.js exposing the application from `src/`. | `Port 80` | `http://localhost:8200` |
| **`db`** | `mysql:8.4` | **Database Server**: Persistent MySQL database using the `db_data` volume. | `Port 3306` | `127.0.0.1:3308` |
| **`phpmyadmin`**| `phpmyadmin:latest` | **Database GUI**: Web interface connected automatically to the `db` service. | `Port 80` | `http://localhost:8201` |

---

## 💡 Useful Operational Commands

*   **Stop containers safely**: `docker compose down`
*   **Monitor logs in real-time**: `docker compose logs -f`
*   **Run all tests (PHPUnit + Vitest)**: `docker exec -it laravel_app npm run test`
*   **Run formatters and linters**: `docker exec -it laravel_app npm run lint` & `docker exec -it laravel_app php vendor/bin/pint`
*   **Run migrations manually**: `docker exec -it laravel_app php artisan migrate`
*   **Wipe and fresh restart database data**: `docker compose down -v && docker compose up -d`
