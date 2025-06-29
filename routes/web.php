<?php
use App\Http\Controllers\InvoiceAssistantController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Welcome');
})->name('home');

Route::get('/invoice-assistant', [InvoiceAssistantController::class, 'index']);
Route::post('/generate-invoice-summary', [InvoiceAssistantController::class, 'generate']);

Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('dashboard', function () {
        return Inertia::render('dashboard');
    })->name('dashboard');
});

// routes/web.php
Route::get('/healthz', function () {
    return response()->json(['status' => 'ok']);
});

require __DIR__.'/settings.php';
require __DIR__.'/auth.php';
