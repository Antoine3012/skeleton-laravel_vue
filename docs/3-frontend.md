# 🎨 Développement Frontend (Vue 3, Inertia.js, Vite & Tailwind)

Ce document décrit le fonctionnement et la gestion de la partie frontend de notre application, basée sur **Vue.js 3** (en Script Setup), **Inertia.js**, **Vite** et **Tailwind CSS**.

---

## 🔗 Le Pont Inertia.js

**Inertia.js** permet de créer une application monopage (SPA) sans la complexité des API REST traditionnelles. Il sert de connecteur entre vos contrôleurs Laravel et vos vues Vue.js.

### Exemple de fonctionnement
1. **La Route Laravel** (`src/routes/web.php`) :
   ```php
   use Inertia\Inertia;

   Route::get('/dashboard', function () {
       return Inertia::render('Dashboard', [
           'userName' => 'Jean Dupont' // Données envoyées au composant Vue
       ]);
   })->middleware(['auth']);
   ```

2. **Le Composant Vue** (`src/resources/js/Pages/Dashboard.vue`) :
   ```vue
   <script setup>
   import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
   import { Head } from '@inertiajs/vue3';

   // Réception des variables envoyées par Laravel
   defineProps({
       userName: String
   });
   </script>

   <template>
       <Head title="Dashboard" />
       
       <AuthenticatedLayout>
           <div class="p-6">
               <p>Bienvenue, {{ userName }} ! Vous êtes connecté.</p>
           </div>
       </AuthenticatedLayout>
   </template>
   ```

---

## 📂 Structure et Aliases de Chemin

Pour simplifier vos imports de composants, le projet est configuré avec un alias `@` pointant directement vers `src/resources/js/`. 

*   Au lieu de faire : `import Button from '../../Components/Button.vue';`
*   Vous pouvez simplement écrire : `import Button from '@/Components/Button.vue';`

Cette configuration est gérée dans le fichier `src/jsconfig.json` et comprise par Vite grâce au plugin Laravel.

---

## ⚡ Compilation des Assets avec Vite

Le projet utilise **Vite** pour compiler le CSS et le Javascript de manière quasi instantanée. Deux modes s'offrent à vous :

### 1. Le Mode Production (Recommandé par défaut avec Docker)
Lorsque vous démarrez le conteneur pour la première fois (ou via le script `entrypoint.sh`), Docker compile automatiquement les assets en mode production :
```bash
docker exec -it laravel_app npm run build
```
Les fichiers compilés et minifiés sont générés dans `src/public/build/`. Le serveur Apache sert ces fichiers statiques de manière extrêmement rapide. 

> *Chaque modification sur vos composants Vue nécessite de relancer la compilation pour être visible si vous utilisez ce mode.*

### 2. Le Mode Développement (Hot-Reload / HMR)
Pour voir vos modifications s'appliquer instantanément dans votre navigateur sans recharger la page, vous devez lancer le serveur de développement Vite. 

Deux méthodes s'offrent à vous :

#### Méthode A : Lancer Vite localement (La plus simple et performante)
Si vous possédez **Node.js 20+** installé directement sur votre ordinateur physique :
1. Allez dans le dossier `src` de votre machine hôte :
   ```bash
   cd src
   ```
2. Installez les dépendances localement (une seule fois) :
   ```bash
   npm install
   ```
3. Lancez le serveur de développement Vite :
   ```bash
   npm run dev
   ```
*Le backend (Laravel, PHP, MySQL) tourne dans Docker, tandis que le serveur de dev Vite tourne localement et envoie les changements à chaud sur [http://localhost:8200](http://localhost:8200).*

#### Méthode B : Lancer Vite à l'intérieur du conteneur Docker
Si vous ne souhaitez pas installer Node.js sur votre machine hôte, vous devez autoriser Docker à communiquer sur le port de Vite (5173) :

1. Ouvrez `compose.yml` et ajoutez le port `5173` au service `app` :
   ```yaml
   services:
     app:
       # ...
       ports:
         - "${APP_PORT:-8200}:80"
         - "5173:5173"  # Ajoutez cette ligne
   ```
2. Ouvrez `src/vite.config.js` et configurez le serveur pour écouter toutes les interfaces :
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
3. Redémarrez le conteneur et lancez le serveur de développement :
   ```bash
   docker compose up -d
   docker exec -it laravel_app npm run dev
   ```

---

## 🎨 Utilisation de Tailwind CSS

Le projet intègre **Tailwind CSS** prêt à l'emploi. 

*   Le fichier de configuration principal est situé dans `src/tailwind.config.js`. Vous pouvez y ajouter des couleurs personnalisées ou modifier les thèmes.
*   Les styles de base et les utilitaires Tailwind sont importés dans `src/resources/css/app.css` :
    ```css
    @tailwind base;
    @tailwind components;
    @tailwind utilities;
    ```

Toutes les classes Tailwind écrites dans vos fichiers `.vue` ou templates Blade seront automatiquement analysées par Vite au moment du build ou du développement à chaud et compilées dans le fichier CSS final.

---

## ➡️ Étape Suivante
Pour comprendre la gestion de la base de données MySQL, des migrations de tables et de phpMyAdmin, consultez le **[Guide de Base de Données (docs/4-database.md)](4-database.md)**.
