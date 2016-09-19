<!DOCTYPE html>
<html ng-app="app">
<head>
  <base href="/" />
  <title>Project</title>
  <meta charset="utf-8" />
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet" />
  <link href="css/style.css" rel="stylesheet" type="text/css" />
</head>
<body ng-cloak>
  <header ng-if="authenticated">
    <nav class="navbar navbar-default">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" ui-sref="/">Brand</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li><a href="users">Users</a></li>
        <li><a href="auth">Auth</a></li>
        <li><a href="register">Registration</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li ng-if="authenticated"><a href="#" ng-click="logout()">Logout</a></li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
  </header>
  <div class="container">
    <div class="content">

      <div ui-view></div>

    </div>
  </div>

    <!-- Application Dependencies -->
    <script src='js/global.min.js'></script>
    <!-- Application Scripts -->
    <script src="js/app.js"></script>
</body>
</html>
