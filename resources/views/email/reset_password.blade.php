<!DOCTYPE html>
<html lang="en-US">
    <head>
        <meta charset="utf-8">
    </head>
    <body>
      <h2>Hi {{ $emailUser['email'] }}</h2>
      <p>A password reset request has been recieved for your login at CRM</p>
      <p><p>To reset your password, please follow this link: <a href="{{ URL::to('user/reset_password/' . $emailUser['reset_password_code']) }}">Change password</a></p>
      <p>Thanks!</p></p>
    </body>
</html>
