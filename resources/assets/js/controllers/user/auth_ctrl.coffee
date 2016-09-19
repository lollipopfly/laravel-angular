AuthController = ($scope, $auth, $state, $http, $rootScope) ->
  vm = this

  vm.login = ->
    credentials =
      email: vm.email
      password: vm.password
    # Use Satellizer's $auth service to login
    $auth.login(credentials).then((->
      # Return an $http request for the now authenticated
      # user so that we can flatten the promise chain
      $http.get 'api/authenticate/user'
      # Handle errors
    ), (error) ->
      console.log(error);
      vm.loginError = true
      $scope.loginErrorText = error.data.error
      # Because we returned the $http.get request in the $auth.login
      # promise, we can chain the next promise to the end here
      return
    ).then (response) ->
      console.log(response);
      user = JSON.stringify(response.data.user)
      localStorage.setItem 'user', user
      $rootScope.authenticated = true
      $rootScope.currentUser = response.data.user

      $state.go 'users'
      return
    return

  return

'use strict'
angular.module('app').controller 'AuthController', AuthController
