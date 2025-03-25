<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\PauloController;

Route::get('/', [PauloController::class, 'index']);
