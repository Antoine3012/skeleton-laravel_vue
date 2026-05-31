# 🧪 Automated Testing

## 🏗️ Test Directory Structure

All test files are centralized in the `src/tests` directory to maintain a clean structure:

```
src/tests/
├── Feature/              # PHPUnit feature tests (API, controllers, complete flows)
├── Unit/                 # PHPUnit unit tests (pure classes, helpers, services)
├── Frontend/             # Frontend unit & component tests (Vitest)
│   └── Components/       # Vue component tests (e.g., TextInput.spec.js)
└── TestCase.php          # Base TestCase class for PHPUnit
```

---

## ⚙️ Test Suite Configuration

### 1. Backend (PHPUnit)
PHPUnit tests run in-memory using **SQLite** (`:memory:`) to ensure maximum speed and avoid polluting your development MySQL database.
The configuration is defined in `src/phpunit.xml`.

### 2. Frontend (Vitest)
Vitest tests run using **happy-dom** to emulate a browser environment without heavy system overhead.
The configuration is merged with the bundler via `src/vitest.config.js`.

---

## 🚀 Running the Tests

You can run the tests either directly on your host machine (if PHP and Node.js are installed) or inside your Docker container `laravel_app` (recommended).

### 1. Run ALL Tests (Backend + Frontend)
This command runs both the Vue component tests (Vitest) and the Laravel backend tests (PHPUnit) in sequence:

* **Inside the Docker container (Recommended):**
  ```bash
  docker exec -it laravel_app npm run test
  ```
* **On the host machine:**
  ```bash
  cd src && npm run test
  ```

### 2. Run ONLY Frontend Unit/Component Tests (Vitest)
To run the Vue component tests once:

* **Inside the Docker container:**
  ```bash
  docker exec -it laravel_app npm run test:unit
  ```
* **Interactive mode (Watch Mode - Host recommended):**
  ```bash
  cd src && npm run test:unit:watch
  ```

### 3. Run ONLY Backend Tests (PHPUnit)
To run the Laravel unit and integration tests:

* **Inside the Docker container:**
  ```bash
  docker exec -it laravel_app npm run test:php
  ```
* **Or via direct Artisan command:**
  ```bash
  docker exec -it laravel_app php artisan test
  ```

---

## 📝 Writing New Tests

### Example Vue Component Test (Vitest)
Create a file ending in `.spec.js` inside the `tests/Frontend/` directory:
```javascript
import { mount } from '@vue/test-utils';
import { describe, it, expect } from 'vitest';
import TextInput from '../../resources/js/Components/TextInput.vue';

describe('TextInput.vue', () => {
    it('displays initial value', () => {
        const wrapper = mount(TextInput, {
            props: { modelValue: 'value' }
        });
        expect(wrapper.find('input').element.value).toBe('value');
    });
});
```

### Example Backend Test (PHPUnit)
Create a class inside the `tests/Unit/` directory:
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

| ⬅️ [Docker & Troubleshooting (Step 5)](5-docker-troubleshooting.md) | 🏠 [Back to Home](../../README.md) | [Continuous Integration (Step 7) ➡️](7-ci-cd.md) |
