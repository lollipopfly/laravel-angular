<?php

Route::get('/', function () {
  return view('index');
});

// Public
Route::get('users', function() { return view('index'); });
Route::get('user/sign_in', function() { return view('index'); });
Route::get('user/sign_up', function() { return view('index'); });
Route::get('user/sign_up_success', function() { return view('index'); });
Route::get('user/confirm/{confirmation_code}', function() { return view('index'); });
Route::get('user/forgot_password', function() { return view('index'); });
Route::get('user/reset_password/{reset_password_code}', function() { return view('index'); });