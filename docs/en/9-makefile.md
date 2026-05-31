# 🛠️ Command Simplification with Makefile

## 📖 General Usage

All commands must be executed from the root directory of the project (where the `Makefile` is located).

To display the interactive help menu with the full list of commands:
```bash
make
# or
make help
```

---

## 🗂️ Available Commands List

### 🐳 Docker Management

| Command | Actual Action | Role |
| :--- | :--- | :--- |
| `make up` | `docker compose up -d` | Start the containers in the background (detached). |
| `make down` | `docker compose down` | Stop and remove containers and networks. |
| `make restart` | `docker compose down && docker compose up -d` | Safely restart all containers in the stack. |
| `make logs` | `docker compose logs -f` | View and follow logs in real-time. |
| `make ps` | `docker compose ps` | List running containers and their exposed ports. |
| `make build` | `docker compose build` | Rebuild the project's Docker images. |
| `make shell` | `docker exec -it laravel_app bash` | Open an interactive `bash` shell inside the main container. |
| `make db-reset` | `docker compose down -v && docker compose up -d` | **Full reset**: delete database volumes and start from scratch. |

---

### 📦 Dependencies & Initialization

| Command | Actual Action | Role |
| :--- | :--- | :--- |
| `make install` | `docker exec -it laravel_app composer install && npm install` | Install all PHP and JavaScript dependencies. |
| `make key-generate` | `docker exec -it laravel_app php artisan key:generate` | Generate the Laravel `.env` application security key. |

---

### 🗄️ Database (Artisan)

| Command | Actual Action | Role |
| :--- | :--- | :--- |
| `make migrate` | `docker exec -it laravel_app php artisan migrate` | Execute new SQL migrations. |
| `make migrate-fresh`| `docker exec -it ... php artisan migrate:fresh --seed` | Reset database and run all migrations with seeders. |
| `make seed` | `docker exec -it laravel_app php artisan db:seed` | Populate database with seeders. |

---

### 💎 Code Quality & Formatting

| Command | Actual Action | Role |
| :--- | :--- | :--- |
| `make lint` | `docker exec -it laravel_app npm run lint` | Static analysis and JS/Vue error fixing (ESLint). |
| `make format` | Runs `npm run format` & `php vendor/bin/pint` | Automatically format PHP, JS, CSS, and Vue code. |
| `make format-check` | Runs `npm run format:check` & `pint --test` | Check if code complies with styling standards (without modifying it). |
| `make pint` | `docker exec -it laravel_app php vendor/bin/pint` | Format PHP code using Laravel Pint. |
| `make pint-test` | `docker exec -it ... php vendor/bin/pint --test` | Test PHP code styling without writing changes (ideal for CI). |

---

### 🧪 Automated Tests

| Command | Actual Action | Role |
| :--- | :--- | :--- |
| `make test` | `docker exec -it laravel_app npm run test` | Run all tests (Vitest + PHPUnit). |
| `make test-php` | `docker exec -it laravel_app php artisan test` | Run only backend PHP unit and integration tests (PHPUnit). |
| `make test-js` | `docker exec -it laravel_app npm run test:unit` | Run only frontend unit tests (Vitest). |

---

## 💡 Example of a Daily Workflow

1. **Morning start**: `make up` to launch the working environment.
2. **After pulling updates (`git pull`)**: `make install` then `make migrate` to update dependencies and database schema.
3. **Before committing code**: `make format` to ensure everything is clean and formatted.
4. **Before pushing your branch (`git push`)**: `make test` to verify that no regression has been introduced.
5. **Evening stop**: `make down` to shut down the containers cleanly and free system resources.

---

## 🧭 Navigation

| ⬅️ [Code Quality (Step 8)](8-code-quality.md) | 🏠 [Back to Home](../../README.md) |
