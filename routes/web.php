<?php
use Illuminate\Http\Request;

Auth::routes();

Route::get('/{any}', 'AppController@index')->where('any', '.*');
