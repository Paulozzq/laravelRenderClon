<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\PauloController;


Route::get('/', function () {
    return view('welcome');
});

Route::get('/hello', [PauloController::class, 'index']);
