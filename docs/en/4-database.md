# 🗄️ Database Management

This document explains the integration of the **MySQL 8.4** database service, how to manage your Laravel migrations, and how to connect using phpMyAdmin or an external SQL graphical interface.

---

## ⚙️ Global Configuration

The MySQL service is defined inside the `compose.yml` file as follows:

*   **Image**: `mysql:8.4` (LTS release).
*   **Internal Port**: `3306` (used inside the Docker network by the Laravel `app` service).
*   **External Port**: `3308` (exposed to your host machine).
*   **Persistent Volume**: `db_data` (avoids data loss when the Docker environment is stopped).

Connection credentials are defined inside the root `.env` file (and mirrored inside `src/.env`).

---

## 🧪 Testing Database & SQL Initialization

When the MySQL container boots for the first time, the SQL script `docker/mysql/init.sql` runs automatically:
```sql
CREATE DATABASE IF NOT EXISTS `default_test_db`;
GRANT ALL PRIVILEGES ON `default_test_db`.* TO 'default_user'@'%';
FLUSH PRIVILEGES;
```
This script creates a distinct, isolated test database named `default_test_db`. This ensures you can run Laravel automated integration and unit tests without affecting your main development database.

---

## 🚀 Migrations and Seeders

### 1. Automatic Execution
Every time you run `docker compose up -d`, the entrypoint script inside the `app` container automatically runs:
```bash
php artisan migrate --force
```
This guarantees that your database schema remains in sync with the latest code pulled from your repository.

### 2. Executing Manual Database / Artisan Commands
All database commands should be executed inside the `laravel_app` container so PHP can access the internal Docker database host:

*   **Create a new migration file:**
    ```bash
    docker exec -it laravel_app php artisan make:migration create_posts_table
    ```
*   **Run migrations manually:**
    ```bash
    docker exec -it laravel_app php artisan migrate
    ```
*   **Roll back migrations:**
    ```bash
    docker exec -it laravel_app php artisan migrate:rollback
    ```
*   **Fresh reset of the database (Drops all tables and re-migrates):**
    ```bash
    docker exec -it laravel_app php artisan migrate:fresh
    ```
*   **Populate the database with seed data:**
    ```bash
    docker exec -it laravel_app php artisan db:seed
    ```

---

## 🌐 Connecting to phpMyAdmin (Web Interface)

To administer your database using your browser:
1.  Navigate to **[http://localhost:8201](http://localhost:8201)**.
2.  Log in using the values defined inside the root `.env` file:
    *   **Server**: `db` (Important: Do not use `localhost` or `127.0.0.1` here. phpMyAdmin runs inside its own container and must target the name of the MySQL service `db` within the internal Docker network).
    *   **Username**: `default_user` *(defined in the root `.env`)*.
    *   **Password**: `default_password` *(defined in the root `.env`)*.

---

## 🔌 Connecting from an External SQL Client (DBeaver, DataGrip, TablePlus...)

If you prefer using your favorite desktop database client:

1.  Create a new **MySQL** connection inside your GUI tool.
2.  Provide the following parameters:
    *   **Host**: `127.0.0.1` or `localhost`
    *   **Port**: `3308` (which binds to internal port `3306` inside the MySQL container).
    *   **Database**: `default_db` *(or the `DB_NAME` value from the root `.env`)*.
    *   **Username**: `default_user` *(or the `DB_USER` value from the root `.env`)*.
    *   **Password**: `default_password` *(or the `DB_PASSWORD` value from the root `.env`)*.

> [!TIP]
> If the connection fails, verify that the `laravel_db` container is running and healthy using `docker compose ps`.

---

## 🧭 Navigation

| ⬅️ [Frontend Development (Step 3)](3-frontend.md) | 🏠 [Back to Homepage](../../README.md) | [Docker & Troubleshooting (Step 5) ➡️](5-docker-troubleshooting.md) |
