<?php

Route::get('/', function () {
    return view('index');
});

// Api
Route::group(['prefix' => 'api'], function()
{
  Route::resource('authenticate', 'AuthController', ['only' => ['index']]);
  Route::post('authenticate', 'AuthController@authenticate');

  Route::get('authenticate/get_user', 'AuthController@getAuthenticatedUser');
  Route::post('authenticate/register', 'AuthController@register');
  Route::post('authenticate/confirm', 'AuthController@confirm');
  Route::post('authenticate/send_reset_code', 'AuthController@sendResetCode');
  Route::post('authenticate/reset_password', 'AuthController@resetPassword');
});

// Public
Route::get('users', function() { return view('index'); });
Route::get('user/sign_in', function() { return view('index'); });
Route::get('user/sign_up', function() { return view('index'); });
Route::get('user/sign_up_success', function() { return view('index'); });
Route::get('user/confirm/{confirmation_code}', function() { return view('index'); });
Route::get('user/forgot_password', function() { return view('index'); });
Route::get('user/reset_password/{reset_password_code}', function() { return view('index'); });

