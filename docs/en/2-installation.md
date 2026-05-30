# ⚙️ Installation and Configuration

This guide takes you step-by-step through cloning, configuring, and starting up the development environment on your host machine.

---

## 🛠️ Prerequisites

Before starting, make sure you have installed the following tools on your system:

1.  **Git**: [Git](https://git-scm.com/) to version and clone the code repository.
2.  **Docker**: [Docker Desktop](https://www.docker.com/get-started/) (Windows, macOS, and Linux) or Docker Engine (for Linux distributions without a graphical interface).
3.  **Docker Compose**: Pre-packaged with Docker Desktop, or installed separately on Linux.

> [!NOTE]
> No local installations of PHP, Composer, Node.js, or MySQL are required on your physical machine. Everything runs isolated inside Docker containers.

---

## 🚀 Installation Steps

### 1. Clone the Repository
Get the project code from your Git host:
```bash
git clone <REPOSITORY_URL>
cd skeleton-laravel_vue
```

---

### 2. Configure Docker Environment Variables
At the root of the project, copy the `.env.example` file to `.env`:
```bash
cp .env.example .env
```
This file configures the global behavior of Docker Compose. You can edit the following variables:
*   `DB_NAME`: The database name created at startup.
*   `DB_USER` & `DB_PASSWORD`: Standard MySQL database credentials.
*   `DB_ROOT_PASSWORD`: The root MySQL password.
*   `APP_PORT`: The host port to access the application (default: `8200`).
*   `PHPMYADMIN_PORT`: The host port to access phpMyAdmin (default: `8201`).

---

### 3. Configure Laravel Environment Variables
The Laravel application inside the `src/` directory also needs its own `.env` configuration file. Go to that folder and copy the file:
```bash
cd src
cp .env.example .env
cd ..
```
> [!IMPORTANT]
> The default database settings inside `src/.env` (`DB_HOST=db`, `DB_PORT=3306`, etc.) are pre-configured to match the Docker Compose setup. You do not need to change them under normal circumstances.
> 
> If you customize database credentials or names in the root `.env` (step 2), make sure to mirror **the exact same modifications** in `src/.env` (`DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`).

---

### 4. Boot the Containers
At the root of the project, start the container orchestration in the background:
```bash
docker compose up -d
```

---

## ⏳ What happens on the first startup?

During the first boot, Docker automatically performs several complex operations through the `docker/php/entrypoint.sh` script:

1.  **Download and Build**: Downloads system dependencies and builds the application container image (PHP 8.5 + Apache + Node.js).
2.  **PHP Dependencies**: Runs `composer install` inside the container to install all Laravel framework packages.
3.  **App Key Generation**: Automatically generates the Laravel application key (`APP_KEY`) if missing in `src/.env`.
4.  **Database Migration**: Waits for the MySQL database service to be healthy, then executes migrations (`php artisan migrate --force`).
5.  **Node.js Dependencies**: Automatically executes `npm install` inside the container if the `node_modules` directory is missing.
6.  **Assets Compilation**: Launches `npm run build` to compile the frontend assets (Vue.js and CSS) and serve them through Apache.

> [!TIP]
> This automated process can take **1 to 3 minutes** depending on your internet connection speed and hardware performance. You can watch the real-time installation logs:
> ```bash
> docker compose logs -f app
> ```

---

## 🌐 Service Access Links

Once the setup completes, open your browser and navigate to:

*   **Web Application (Laravel + Vue)**: [http://localhost:8200](http://localhost:8200)
*   **phpMyAdmin (Database Administration)**: [http://localhost:8201](http://localhost:8201)
    *   *Server*: `db`
    *   *Username*: `default_user` (or your custom `DB_USER` from the root `.env`)
    *   *Password*: `default_password` (or your custom `DB_PASSWORD` from the root `.env`)

---

## ⚙️ Resolving Port Conflicts (e.g. port already in use)

If ports `8200` or `8201` are already in use by another local server or project on your computer, the containers will fail to start.

To solve this:
1.  Open the `.env` file at the **root** of the project.
2.  Modify the port variables:
    ```ini
    APP_PORT=8500          # Example alternative port for the web app
    PHPMYADMIN_PORT=8501   # Example alternative port for phpMyAdmin
    ```
3.  Recreate and launch the containers:
    ```bash
    docker compose up -d
    ```
4.  Your application will now be available on [http://localhost:8500](http://localhost:8500).

---

## 🧭 Navigation

| ⬅️ [Architecture (Step 1)](1-architecture.md) | 🏠 [Back to Homepage](../../README.md) | [Frontend Development (Step 3) ➡️](3-frontend.md) |
