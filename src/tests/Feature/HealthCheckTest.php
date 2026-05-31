<?php

namespace Tests\Feature;

use Illuminate\Foundation\Events\DiagnosingHealth;
use Illuminate\Support\Facades\Event;
use Tests\TestCase;

class HealthCheckTest extends TestCase
{
    /**
     * Test the health check endpoint returns 200 and "up" in JSON when everything is healthy.
     */
    public function test_health_check_returns_success_when_healthy(): void
    {
        $response = $this->getJson('/up');

        $response->assertStatus(200)
            ->assertJson(['status' => 'up']);
    }

    /**
     * Test the health check endpoint returns 500 when a health diagnostic fails.
     */
    public function test_health_check_returns_error_when_diagnostic_fails(): void
    {
        // Disable debug mode for this test to simulate production-like error handling
        // and prevent the exception from being rethrown by Laravel's health routing.
        config(['app.debug' => false]);

        // Register a listener that throws an exception to simulate a diagnostic failure
        Event::listen(DiagnosingHealth::class, function (): void {
            throw new \RuntimeException('Simulated diagnostic failure.');
        });

        $response = $this->getJson('/up');

        $response->assertStatus(500)
            ->assertJson(['status' => 'down']);
    }
}
