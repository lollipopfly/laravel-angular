'use strict'
angular
  .module('app', [
    'ui.router'
    'satellizer'
  ]).config(($stateProvider, $urlRouterProvider, $authProvider, $locationProvider) ->
    # protect link
    _redirectIfNotAuthenticated = ($q, $state, $auth) ->
      defer = $q.defer()
      if $auth.isAuthenticated()
        defer.resolve()
      else
        $timeout ->
          $state.go 'auth'
          return
        defer.reject()
      defer.promise

    $locationProvider.html5Mode true

    # Satellizer configuration that specifies which API
    # route the JWT should be retrieved from
    $authProvider.loginUrl = '/api/authenticate'
    $authProvider.signupUrl = '/api/authenticate/register'

    $urlRouterProvider.otherwise '/auth'

    $stateProvider
      .state('/',
        url: '/'
        templateUrl: '../views/home.html'
        resolve: {
          redirectIfNotAuthenticated: _redirectIfNotAuthenticated
        })

      .state('auth',
        url: '/auth'
        templateUrl: '../views/user/sign_in.html'
        controller: 'AuthController as auth')

      .state('register',
        url: '/register'
        templateUrl: '../views/user/sign_up.html'
        controller: 'RegisterController as register')

      .state('sign-up-success',
        url: '/sign_up_sucess'
        templateUrl: '../views/user/sign_up_success.html'
      )
      .state('confirm',
        url: '/confirm/:confirmation_code'
        controller: 'ConfirmController as confirm'
      )
      .state('forgot_password',
        url: '/forgot_password'
        controller: 'ForgotPasswordController as forgotPassword'
        templateUrl: '../views/user/forgot_password.html'
      )
      .state('restore_password',
        url: '/restore_password/:restore_password_code'
        controller: 'RestorePasswordController as restorePassword'
        templateUrl: '../views/user/restore_password.html'
      )
      .state('users',
        url: '/users'
        templateUrl: '../views/user/users_view.html'
        controller: 'UserController as user'
        resolve: {
          redirectIfNotAuthenticated: _redirectIfNotAuthenticated
        })

    # Get user on every load page
    return
  ).run ($rootScope, $state, $auth, $location, $timeout) ->

    $rootScope.logout = ->
      $auth.logout().then ->
        # Remove the authenticated user from local storage
        localStorage.removeItem 'user'
        # Flip authenticated to false so that we no longer
        # show UI elements dependant on the user being logged in
        $rootScope.authenticated = false
        # Remove the current user info from rootscope
        $rootScope.currentUser = null
        $state.go 'auth'
        return
      return

    # if not logged
    $timeout(() ->
      $rootScope.currentState = $state.current.name

      if !$auth.isAuthenticated() && $rootScope.currentState != 'register' && $rootScope.currentState != 'confirm' && $rootScope.currentState != 'forgot_password' && $rootScope.currentState != 'restore_password'
        # event.preventDefault()
        $location.path 'auth'
        return
    )

    $rootScope.$on '$stateChangeStart', (event, toState) ->
      # Grab the user from local storage and parse it to an object
      user = JSON.parse(localStorage.getItem('user'))

      if user
        $rootScope.authenticated = true

        $rootScope.currentUser = user
        # If the user is logged in and we hit the auth route we don't need
        # to stay there and can send the user to the main state
        if toState.name == 'auth'
          event.preventDefault()
          $state.go '/'
      return
    return