# 🎨 Frontend Development (Vue 3, Inertia.js, Vite & Tailwind)

This document describes how the frontend part of our application works. It is built using **Vue.js 3** (with `<script setup>`), **Inertia.js**, **Vite**, and **Tailwind CSS**.

---

## 🔗 The Inertia.js Bridge

**Inertia.js** allows you to build single-page apps (SPA) without the complexity of traditional REST or GraphQL APIs. It acts as a connector between your Laravel controllers and your Vue.js views.

### Workflow Example
1. **The Laravel Route** (`src/routes/web.php`):
   ```php
   use Inertia\Inertia;

   Route::get('/dashboard', function () {
       return Inertia::render('Dashboard', [
           'userName' => 'John Doe' // Data passed down to the Vue component
       ]);
   })->middleware(['auth']);
   ```

2. **The Vue Component** (`src/resources/js/Pages/Dashboard.vue`):
   ```vue
   <script setup>
   import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
   import { Head } from '@inertiajs/vue3';

   // Access properties sent by Laravel
   defineProps({
       userName: String
   });
   </script>

   <template>
       <Head title="Dashboard" />
       
       <AuthenticatedLayout>
           <div class="p-6">
               <p>Welcome, {{ userName }}! You are logged in.</p>
           </div>
       </AuthenticatedLayout>
   </template>
   ```

---

## 📂 Structure and Path Aliases

To make component imports easier, the project is configured with a `@` path alias pointing to `src/resources/js/`.

*   Instead of doing: `import Button from '../../Components/Button.vue';`
*   You can simply write: `import Button from '@/Components/Button.vue';`

This configuration is defined in the `src/jsconfig.json` file and resolved by Vite using the Laravel plugin.

---

## ⚡ Compiling Assets with Vite

The project uses **Vite** to compile CSS and JavaScript files almost instantly. You have two options for compilation:

### 1. Production Mode (Default with Docker)
When starting the containers for the first time (via `entrypoint.sh`), Docker compiles all assets in production mode:
```bash
docker exec -it laravel_app npm run build
```
Optimized and minified assets are written to the `src/public/build/` directory. The Apache web server serves these static assets very quickly.

> *Every modification on your Vue components requires compiling again to see the changes if you use this mode.*

### 2. Development Mode (Hot Module Replacement / HMR)
To see your frontend edits reflected in the browser instantly without a manual page reload, run the Vite development server.

There are two ways to do this:

#### Method A: Running Vite Locally (Simplest and most performant)
If you have **Node.js 20+** installed on your physical host machine:
1. Navigate to the `src/` directory on your host:
   ```bash
   cd src
   ```
2. Install dependencies locally (only once):
   ```bash
   npm install
   ```
3. Start the Vite development server:
   ```bash
   npm run dev
   ```
*The backend services (Laravel, PHP, MySQL) continue running in Docker, while Vite runs locally, serving modifications instantly on [http://localhost:8200](http://localhost:8200).*

#### Method B: Running Vite inside the Docker Container
If you do not want to install Node.js on your host machine, you must expose Vite's port (5173) in Docker:

1. Open `compose.yml` and bind port `5173` on the `app` service:
   ```yaml
   services:
     app:
       # ...
       ports:
         - "${APP_PORT:-8200}:80"
         - "5173:5173"  # Add this line
   ```
2. Open `src/vite.config.js` and configure the development server to accept external connections:
   ```javascript
   export default defineConfig({
       server: {
           host: '0.0.0.0',
           hmr: {
               host: 'localhost',
           },
       },
       plugins: [
           // ...
       ],
   });
   ```
3. Restart the containers and start the development server inside the app container:
   ```bash
   docker compose up -d
   docker exec -it laravel_app npm run dev
   ```

---

## 🎨 Using Tailwind CSS

The project integrates **Tailwind CSS** out of the box.

*   The main configuration file is located at `src/tailwind.config.js`. You can add custom colors or tweak themes here.
*   Tailwind utility classes and base styles are imported in `src/resources/css/app.css`:
    ```css
    @tailwind base;
    @tailwind components;
    @tailwind utilities;
    ```

Any Tailwind CSS classes you write in your `.vue` components or Blade templates are parsed by Vite and automatically compiled into the final CSS file during compilation.

---

## 🧭 Navigation

| ⬅️ [Installation (Step 2)](2-installation.md) | 🏠 [Back to Homepage](../../README.md) | [Database Management (Step 4) ➡️](4-database.md) |
