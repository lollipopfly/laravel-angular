<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests;
use App\Http\Requests\RegisterRequest;
use JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use App\User;
use Auth;
use Mail;
use Hash;

class AuthenticateController extends Controller
{
    public function __construct(User $user, JWTAuth $jwtauth)
    {
        $this->user = $user;
        $this->jwtauth = $jwtauth;

        $this->middleware('jwt.auth', ['except' => ['authenticate', 'register', 'confirm', 'sendResetCode', 'resetPassword']]);
    }

    /**
     * Return the user
     *
     * @return Response
     */
    public function index()
    {
      // Retrieve all the users in the database and return them
      $users = User::all();

      return $users;
    }

    public function authenticate(Request $request)
    {
      // grab credentials from the request
      $credentials = $request->only('email', 'password');
      try {
        // attempt to verify the credentials and create a token for the user
        if (! $token = JWTAuth::attempt($credentials)) {
            return response()->json(['error' => 'Invalid login or password'], 401);
        }
      } catch (JWTException $e) {
        // something went wrong whilst attempting to encode the token
        return response()->json(['error' => 'could_not_create_token'], 500);
      }

      // all good so return the token
      return response()->json(compact('token'));
    }

    public function register(RegisterRequest $request)
    {
        $confirmation_code = str_random(30);

        $newUser = USER::create([
            'name' => $request->get('name'),
            'email' => $request->get('email'),
            'password' => bcrypt($request->get('password')),
            'confirmation_code' => $confirmation_code
        ]);

        if($newUser) {
          $emailUser = Array(
            "name" => $request->get('name'),
            "email" => $request->get('email'),
            "password" => $request->get('password'),
            "confirmation_code" => $confirmation_code
          );
          $email = Mail::send('email.verify', $emailUser, function($message) use($emailUser){
              $message->to($emailUser['email'], $emailUser['name'])
                      ->subject('Verify your email address');
          });

          return response()->json(true, 200);
        }

        return response()->json(['error' => 'User not added!'], 500);
    }

    public function confirm(Request $request)
    {
      if (!$request->confirmation_code) {
        return response()->json(['error' => 'Url do not has confirmation code!'], 500);
      }

      $user = User::where('confirmation_code', $request->confirmation_code)->first();
      if (!$user) {
        return response()->json(['error' => 'Do not find User'], 500);
      }

      $user->confirmed = 1;
      $user->confirmation_code = null;
      $user->save();

      // Get JWT token
      if (!$token=JWTAuth::fromUser($user)) {
          return response()->json(['error' => 'invalid_credentials'], 401);
      }

      return $token;
    }

    public function getAuthenticatedUser()
    {
      try {
        if (! $user = JWTAuth::parseToken()->authenticate()) {
         return response()->json(['user_not_found'], 404);
        }

      } catch (Tymon\JWTAuth\Exceptions\TokenExpiredException $e) {
        return response()->json(['token_expired'], $e->getStatusCode());

      } catch (Tymon\JWTAuth\Exceptions\TokenInvalidException $e) {
        return response()->json(['token_invalid'], $e->getStatusCode());

      } catch (Tymon\JWTAuth\Exceptions\JWTException $e) {
        return response()->json(['token_absent'], $e->getStatusCode());
      }

      // the token is valid and we have found the user via the sub claim
      return response()->json(compact('user'));
    }

    public function sendResetCode(Request $request)
    {
      $user = User::where('email', $request->email)->first();

      if($user) {
        $reset_password_code = str_random(30);

        $emailUser = Array(
          "name" => $user->name,
           "email" => $user->email,
           "reset_password_code" => $reset_password_code
         );

        $email = Mail::send('email.reset_password', $emailUser, function($message) use($emailUser) {
            $message->to($emailUser['email'], $emailUser['name'])
                    ->subject('Verify your email address');
        });

        if($email) {
          User::where('email', $user->email)->update(['reset_password_code' => $reset_password_code]);
          return response()->json(true, 200);
        }
      }

      return response()->json(['error' => 'Do not find User'], 500);
    }

    public function resetPassword(Request $request)
    {
      $user = User::where('reset_password_code', $request->reset_password_code)->first();

      if($user) {
        $hashad_password = Hash::make($request->password);
        if (Hash::needsRehash($hashad_password)) {
            $hashad_password = Hash::make($request->password);
        }
        $user->password = $hashad_password;
        $user->reset_password_code = Null;
        $user->update();

        return response()->json(true, 200);
      }

      return response()->json(['error' => 'Do not find User'], 500);
    }
}