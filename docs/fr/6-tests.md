# 🧪 Tests Automatisés

## 🏗️ Structure des Dossiers de Test

Tous les fichiers de test sont centralisés dans le répertoire `src/tests` pour conserver une architecture propre :

```
src/tests/
├── Feature/              # Tests fonctionnels PHPUnit (API, contrôleurs, flux complets)
├── Unit/                 # Tests unitaires PHPUnit (classes pures, services)
├── Frontend/             # Tests unitaires & de composants frontend (Vitest)
│   └── Components/       # Tests des composants Vue (ex: TextInput.spec.js)
└── TestCase.php          # Classe de base pour les tests PHPUnit
```

---

## ⚙️ Configuration des Tests

### 1. Backend (PHPUnit)
Les tests PHPUnit s'exécutent en mémoire avec **SQLite** (`:memory:`) pour garantir des performances optimales et éviter de polluer la base de données de développement MySQL.
La configuration est définie dans `src/phpunit.xml`.

### 2. Frontend (Vitest)
Les tests Vitest s'exécutent à l'aide de **happy-dom** pour émuler un environnement de navigateur sans lourdeur graphique.
La configuration est fusionnée avec le bundler via `src/vitest.config.js`.

---

## 🚀 Exécution des Tests

Vous pouvez exécuter les tests soit directement sur votre machine hôte (si PHP et Node.js sont installés), soit au sein de votre conteneur Docker `laravel_app` (recommandé).

### 1. Lancer TOUS les tests (Backend + Frontend)
Cette commande exécute à la fois la suite de tests de composants Vue (Vitest) et la suite de tests Laravel (PHPUnit) :

* **Dans le conteneur Docker (Recommandé) :**
  ```bash
  docker exec -it laravel_app npm run test
  ```
* **Sur la machine hôte :**
  ```bash
  cd src && npm run test
  ```

### 2. Lancer uniquement les tests unitaires Frontend (Vitest)
Pour exécuter les tests sur les composants Vue 3 en mode d'exécution unique :

* **Dans le conteneur Docker :**
  ```bash
  docker exec -it laravel_app npm run test:unit
  ```
* **En mode interactif (Watch Mode - Hôte recommandé) :**
  ```bash
  cd src && npm run test:unit:watch
  ```

### 3. Lancer uniquement les tests Backend (PHPUnit)
Pour exécuter uniquement les tests unitaires et fonctionnels Laravel :

* **Dans le conteneur Docker :**
  ```bash
  docker exec -it laravel_app npm run test:php
  ```
* **Ou via la commande directe Artisan :**
  ```bash
  docker exec -it laravel_app php artisan test
  ```

---

## 📝 Écrire de Nouveaux Tests

### Exemple de test de composant Vue (Vitest)
Créez un fichier se terminant par `.spec.js` dans le dossier `tests/Frontend/` :
```javascript
import { mount } from '@vue/test-utils';
import { describe, it, expect } from 'vitest';
import TextInput from '../../resources/js/Components/TextInput.vue';

describe('TextInput.vue', () => {
    it('affiche la valeur initiale', () => {
        const wrapper = mount(TextInput, {
            props: { modelValue: 'valeur' }
        });
        expect(wrapper.find('input').element.value).toBe('valeur');
    });
});
```

### Exemple de test unitaire PHP (PHPUnit)
Créez une classe dans `tests/Unit/` :
```php
<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;

class MathTest extends TestCase
{
    public function test_addition(): void
    {
        $this->assertEquals(4, 2 + 2);
    }
}
```

---

## 🧭 Navigation

| ⬅️ [Docker & Dépannage (Étape 5)](5-docker-troubleshooting.md) | 🏠 [Retour à l'Accueil](../../README.fr.md) | [Intégration Continue (Étape 7) ➡️](7-ci-cd.md) |
