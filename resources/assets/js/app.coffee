'use strict'

angular
  .module('app', [
    'ui.router'
    'satellizer'
  ]).config(($stateProvider, $urlRouterProvider, $authProvider, $locationProvider) ->
    $locationProvider.html5Mode true
    # Satellizer configuration that specifies which API
    # route the JWT should be retrieved from
    $authProvider.loginUrl = '/api/authenticate'
    $authProvider.signupUrl = '/api/authenticate/register'
    $urlRouterProvider.otherwise '/sign_in'

    # protect link
    _redirectIfNotAuthenticated = ($q, $state, $auth) ->
      defer = $q.defer()
      if $auth.isAuthenticated()
        defer.resolve()
      else
        $timeout ->
          $state.go 'sign_in'
          return
        defer.reject()
      defer.promise

    $stateProvider
      .state('/',
        url: '/'
        templateUrl: '../views/home.html'
        resolve: {
          redirectIfNotAuthenticated: _redirectIfNotAuthenticated
        })

      # USER
      .state('sign_in',
        url: '/user/sign_in'
        templateUrl: '../views/user/sign_in.html'
        controller: 'SignInController as auth'
      )
      .state('sign_up',
        url: '/user/sign_up'
        templateUrl: '../views/user/sign_up.html'
        controller: 'SignUpController as register'
      )
      .state('sign_up_success',
        url: '/user/sign_up_success'
        templateUrl: '../views/user/sign_up_success.html'
      )
      .state('forgot_password',
        url: '/user/forgot_password'
        templateUrl: '../views/user/forgot_password.html'
        controller: 'ForgotPasswordController as forgotPassword'
      )
      .state('reset_password',
        url: '/user/reset_password/:reset_password_code'
        templateUrl: '../views/user/reset_password.html'
        controller: 'ResetPasswordController as resetPassword'
      )
      .state('confirm',
        url: '/user/confirm/:confirmation_code'
        controller: 'ConfirmController'
      )
      .state('users',
        url: '/users'
        templateUrl: '../views/user/users_view.html'
        controller: 'UserController'
        resolve: {
          redirectIfNotAuthenticated: _redirectIfNotAuthenticated
        })

    # Get user on every load page
    return
  ).run ($rootScope, $state, $auth, $location, $timeout) ->

    $rootScope.logout = ->
      $auth.logout().then ->
        localStorage.removeItem 'user'
        $rootScope.authenticated = false
        $rootScope.currentUser = null
        $state.go 'sign_in'
        return
      return

    # if not logged
    $timeout(() ->
      $rootScope.currentState = $state.current.name

      ### TODO: Refactoring###
      if !$auth.isAuthenticated() && $rootScope.currentState != 'register' && $rootScope.currentState != 'confirm' && $rootScope.currentState != 'forgot_password' && $rootScope.currentState != 'reset_password'
        $location.path 'user/sign_in'
        return
    )

    $rootScope.$on '$stateChangeStart', (event, toState) ->
      user = JSON.parse(localStorage.getItem('user'))

      if user
        $rootScope.authenticated = true
        $rootScope.currentUser = user
        # If the user is logged in and we hit the auth route we don't need
        # to stay there and can send the user to the main state
        if toState.name == 'sign_in'
          event.preventDefault()
          $state.go '/'
      return
    return
