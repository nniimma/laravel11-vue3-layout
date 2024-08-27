<?php

namespace App\Http\Controllers;

use Inertia\Inertia;

class SobreController extends Controller
{
    public function index()
    {
        return Inertia::render('Sobre/Index');
    }
}
