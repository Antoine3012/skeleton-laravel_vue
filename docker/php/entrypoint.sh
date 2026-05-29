#!/bin/sh
set -e

# Copy .env if not exists
if [ ! -f ".env" ]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
fi

# Install dependencies if vendor folder is missing
if [ ! -d "vendor" ]; then
    echo "Installing Composer dependencies..."
    composer install --no-interaction --optimize-autoloader
fi

# Generate key if not set
if ! grep -q "APP_KEY=base64" .env || [ -z "$(grep APP_KEY .env | cut -d '=' -f2)" ]; then
    echo "Generating Laravel application key..."
    php artisan key:generate --force
fi

# Run migrations
echo "Running Laravel database migrations..."
php artisan migrate --force

# Install Node dependencies if node_modules is missing
if [ ! -d "node_modules" ]; then
    echo "Installing NPM dependencies..."
    npm install
fi

# Clean up Vite hot reload file to force Laravel to use compiled assets
if [ -f "public/hot" ]; then
    echo "Removing Vite hot reload file..."
    rm -f public/hot
fi

# Build Vite assets if build folder is missing
if [ ! -d "public/build" ]; then
    echo "Building assets with Vite..."
    npm run build
fi

echo "Starting Apache..."
exec "$@"
