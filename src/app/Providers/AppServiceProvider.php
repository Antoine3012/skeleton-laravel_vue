<?php

namespace App\Providers;

use Illuminate\Foundation\Events\DiagnosingHealth;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Vite;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Vite::prefetch(concurrency: 3);

        Event::listen(DiagnosingHealth::class, function (): void {
            DB::connection()->getPdo();

            Cache::store()->put('health_check_temp', true, 10);
            if (!Cache::store()->get('health_check_temp')) {
                throw new \RuntimeException('The cache store is not functioning correctly.');
            }
            Cache::store()->forget('health_check_temp');

            $paths = [
                storage_path('framework/cache'),
                storage_path('logs'),
            ];

            foreach ($paths as $path) {
                if (!is_writable($path)) {
                    throw new \RuntimeException(sprintf('The directory [%s] is not writable.', $path));
                }
            }
        });
    }
}
