.DEFAULT_GOAL := help

# Configuration
CONTAINER_NAME := laravel_app
EXEC := docker exec -it $(CONTAINER_NAME)

##@ 🐳 Docker
up: ## Démarrer les conteneurs en arrière-plan (detached)
	docker compose up -d

down: ## Arrêter les conteneurs et nettoyer les réseaux
	docker compose down

restart: ## Redémarrer tous les conteneurs
	docker compose down
	docker compose up -d

logs: ## Consulter les journaux (logs) en temps réel
	docker compose logs -f

ps: ## Afficher l'état des conteneurs
	docker compose ps

build: ## Reconstruire les images Docker
	docker compose build

shell: ## Entrer dans le conteneur applicatif (Bash)
	docker exec -it $(CONTAINER_NAME) bash

db-reset: ## Réinitialiser complètement la base de données (suppression des volumes)
	docker compose down -v
	docker compose up -d

##@ 📦 Installation & Dépendances
install: ## Installer les dépendances Composer et NPM
	$(EXEC) composer install
	$(EXEC) npm install

key-generate: ## Générer la clé de sécurité Laravel
	$(EXEC) php artisan key:generate

##@ 🗄️ Base de données (Artisan)
migrate: ## Exécuter les migrations de base de données
	$(EXEC) php artisan migrate

migrate-fresh: ## Réinitialiser et ré-exécuter toutes les migrations avec les seeders
	$(EXEC) php artisan migrate:fresh --seed

seed: ## Exécuter les seeders de base de données
	$(EXEC) php artisan db:seed

##@ 💎 Qualité & Formatage de Code
lint: ## Analyser le code frontend (ESLint)
	$(EXEC) npm run lint

format: ## Formater le code frontend (Prettier) et PHP (Laravel Pint)
	$(EXEC) npm run format
	$(EXEC) php vendor/bin/pint

format-check: ## Vérifier le formatage du code sans le modifier
	$(EXEC) npm run format:check
	$(EXEC) php vendor/bin/pint --test

pint: ## Formater le code PHP avec Laravel Pint
	$(EXEC) php vendor/bin/pint

pint-test: ## Vérifier le style PHP avec Laravel Pint
	$(EXEC) php vendor/bin/pint --test

##@ 🧪 Tests
test: ## Exécuter tous les tests (Vitest + PHPUnit)
	$(EXEC) npm run test

test-php: ## Exécuter uniquement les tests PHPUnit (Backend)
	$(EXEC) php artisan test

test-js: ## Exécuter uniquement les tests Vitest (Frontend)
	$(EXEC) npm run test:unit

##@ Aide
help: ## Afficher cette aide
	@echo "========================================================================="
	@echo "                SKELETON LARAVEL & VUE - MAKEFILE"
	@echo "========================================================================="
	@echo "Utilisation: make <commande>"
	@echo ""
	@echo "DOCKER"
	@echo "  make up             Demarrer les conteneurs en arriere-plan (detached)"
	@echo "  make down           Arreter les conteneurs et nettoyer les reseaux"
	@echo "  make restart        Redemarrer tous les conteneurs"
	@echo "  make logs           Consulter les journaux (logs) en temps reel"
	@echo "  make ps             Afficher l'etat des conteneurs"
	@echo "  make build          Reconstruire les images Docker"
	@echo "  make shell          Entrer dans le conteneur applicatif (Bash)"
	@echo "  make db-reset       Reinitialiser completement la base de donnees"
	@echo ""
	@echo "INSTALLATION & DEPENDANCES"
	@echo "  make install        Installer les dependances Composer et NPM"
	@echo "  make key-generate   Generer la cle de securite Laravel"
	@echo ""
	@echo "BASE DE DONNEES (ARTISAN)"
	@echo "  make migrate        Executer les migrations de base de donnees"
	@echo "  make migrate-fresh  Reinitialiser et re-executer les migrations avec seeders"
	@echo "  make seed           Executer les seeders de base de donnees"
	@echo ""
	@echo "QUALITE & FORMATAGE DE CODE"
	@echo "  make lint           Analyser le code frontend (ESLint)"
	@echo "  make format         Formater le code frontend (Prettier) et PHP (Pint)"
	@echo "  make format-check   Verifier le formatage du code sans le modifier"
	@echo "  make pint           Formater le code PHP avec Laravel Pint"
	@echo "  make pint-test      Verifier le style PHP avec Laravel Pint"
	@echo ""
	@echo "TESTS"
	@echo "  make test           Executer tous les tests (Vitest + PHPUnit)"
	@echo "  make test-php       Executer uniquement les tests PHPUnit (Backend)"
	@echo "  make test-js        Executer uniquement les tests Vitest (Frontend)"
	@echo "========================================================================="
