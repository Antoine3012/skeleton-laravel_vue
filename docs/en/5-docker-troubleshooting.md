# 🐳 Docker & Troubleshooting

## 🛠️ Essential Docker Compose Commands

All these commands must be run from the root of the project (where the `compose.yml` file is located).

### 1. Containers Lifecycle
*   **Start the environment (in background mode):**
    ```bash
    docker compose up -d
    ```
*   **Stop all containers (without losing data):**
    ```bash
    docker compose down
    ```
*   **Stop and wipe all data (⚠️ Deletes the Database completely):**
    ```bash
    docker compose down -v
    ```
    *(Useful to force-reset MySQL and re-run the `init.sql` initialization scripts).*

### 2. Logs and Monitoring
*   **List all running containers and health status:**
    ```bash
    docker compose ps
    ```
*   **View real-time logs from all services:**
    ```bash
    docker compose logs -f
    ```
*   **View real-time logs from the web/PHP container only:**
    ```bash
    docker compose logs -f app
    ```
*   **View real-time logs from the database container only:**
    ```bash
    docker compose logs -f db
    ```

---

## 💻 Executing Commands inside the App Container

To avoid local differences in PHP or Node.js versions between your physical machine and the server, always use `docker exec` to run commands inside the `laravel_app` container.

### Fast Shortcuts
*   **Open a terminal shell (Bash) inside the container:**
    ```bash
    docker exec -it laravel_app /bin/bash
    ```
*   **Laravel Artisan commands:**
    ```bash
    docker exec -it laravel_app php artisan <command>
    ```
*   **Composer commands:**
    ```bash
    docker exec -it laravel_app composer <command>
    ```
*   **NPM / Node.js commands:**
    ```bash
    docker exec -it laravel_app npm <command>
    ```

---

## 🔍 Common Troubleshooting (FAQ)

### 1. Port conflict at startup (`port is already allocated`)
*   **Symptom**: When running `docker compose up -d`, you get an error message indicating that a port is already in use.
*   **Cause**: Another local server (like XAMPP, WampServer, another Docker stack, or a native MySQL server) is already listening on ports `8200`, `8201`, or `3308`.
*   **Solution**:
    1.  Open the `.env` file at the root of the project.
    2.  Change the `APP_PORT` or `PHPMYADMIN_PORT` variables (e.g., set them to `8500` and `8501`).
    3.  If MySQL port `3308` is taken, edit `compose.yml` on the `db` service external port binding:
        ```yaml
        ports:
          - "3309:3306" # Replace 3308 with 3309
        ```
    4.  Restart the environment: `docker compose up -d`.

---

### 2. File permissions issue (Linux/macOS)
*   **Symptom**: Laravel displays a crash page showing `The stream or file "/var/www/html/storage/logs/laravel.log" could not be opened: permission denied`.
*   **Cause**: On Unix systems (Linux, macOS), user IDs (UIDs) between your host system and the internal container user (`www-data`) may differ, locking Laravel out of write operations in the `storage/` or `bootstrap/cache/` directories.
*   **Solution**:
    Assign owner permissions to the web server user inside the container:
    ```bash
    docker exec -it laravel_app chown -R www-data:www-data storage bootstrap/cache
    ```
    Alternatively, open write permissions for local testing:
    ```bash
    docker exec -it laravel_app chmod -R 777 storage bootstrap/cache
    ```

---

### 3. Corrupted or incomplete packages (Composer/NPM)
*   **Symptom**: You see PHP compilation issues, missing classes, or strange Vite JavaScript build failures.
*   **Cause**: An interrupted installation has corrupted the `vendor/` or `node_modules/` folders.
*   **Solution**:
    1.  Delete the `src/vendor` and `src/node_modules` folders from your computer.
    2.  Stop and restart the environment:
        ```bash
        docker compose down
        docker compose up -d
        ```
    3.  The startup script `entrypoint.sh` will notice these directories are gone and cleanly download/install all dependencies from scratch.

---

### 4. Forcing image rebuild without cached layers
*   **Symptom**: You updated the `Dockerfile` or Apache configurations, but your modifications do not show up.
*   **Solution**:
    Force Docker to rebuild the application container image ignoring cache layers:
    ```bash
    docker compose build --no-cache
    docker compose up -d
    ```

---

## 🧭 Navigation

| ⬅️ [Database Management (Step 4)](4-database.md) | 🏠 [Back to Homepage](../../README.md) | [Automated Testing (Step 6) ➡️](6-tests.md) |

