ConfirmController = ($scope, $auth, $state, $http, $rootScope, $stateParams) ->
  vm = this
  $scope.data = {
    confirmation_code: $stateParams.confirmation_code
  }

  $http.post('api/authenticate/confirm', $scope.data)
    .then (response) ->
      # Save token
      $auth.setToken(response.data.token)

      # Save user in localStorage
      user = JSON.stringify(response.data)
      localStorage.setItem 'user', user
      $rootScope.authenticated = true
      $rootScope.currentUser = response.data

      $state.go 'users'
    , (error) ->
      console.log(error);

  return

'use strict'
angular
  .module('app')
  .controller('ConfirmController', ConfirmController)
