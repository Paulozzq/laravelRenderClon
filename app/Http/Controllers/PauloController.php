<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class PauloController extends Controller
{
    public function index()
    {
        return view('hello');
    }
}
