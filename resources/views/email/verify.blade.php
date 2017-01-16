<!DOCTYPE html>
<html lang="en-US">
    <head>
        <meta charset="utf-8">
    </head>
    <body>
      <h2>Verify Your Email Address</h2>

      <p>Thanks for creating an account.</p>
      <p>Please follow the link below to verify your email address</p>
      <p>
        {{ URL::to('user/confirm/' . $emailUser['confirmation_code']) }}.<br/>
      </p>

      <p>
        Your login details
        <br>
        E-mail: <a href="/compose?To={{ $emailUser['email'] }}" rel="noopener">{{ $emailUser['email'] }}</a>
        <br>
        Password: {{ $emailUser['password'] }}
      </p>
    </body>
</html>
