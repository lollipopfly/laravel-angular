<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

Route::get('/', function () {
    return view('index');
});

// View::addExtension('html', 'php');

// api
Route::group(['prefix' => 'api'], function()
{
    Route::resource('authenticate', 'AuthenticateController', ['only' => ['index']]);
    Route::post('authenticate', 'AuthenticateController@authenticate');

    Route::get('authenticate/user', 'AuthenticateController@getAuthenticatedUser'); // auth
    Route::post('authenticate/register', 'AuthenticateController@register'); // registration
    Route::post('authenticate/confirm', 'AuthenticateController@confirm');
    Route::post('authenticate/send_restore_code', 'AuthenticateController@sendRestoreCode');
    Route::post('authenticate/restore_password', 'AuthenticateController@restorePassword');
    // Route::resource('users', 'UsersController');
});

// Public
Route::get('users', function() { return view('index'); });
Route::get('auth', function() { return view('index'); });
Route::get('register', function() { return view('index'); });
Route::get('sign_up_sucess', function() { return view('index'); });
Route::get('confirm/{confirmation_code}', function() { return view('index'); });
Route::get('forgot_password', function() { return view('index'); });
Route::get('restore_password/{restore_password_code}', function() { return view('index'); });

