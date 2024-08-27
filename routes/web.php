<?php

use App\Http\Controllers\HomeController;
use App\Http\Controllers\SobreController;
use Illuminate\Support\Facades\Route;

// home
Route::get('/', [HomeController::class, 'index'])->name('home.index');
// home

// sobre
Route::get('/sobre', [SobreController::class, 'index'])->name('sobre.index');
// sobre
