ConfirmController = ($scope, $auth, $state, $http, $rootScope, $stateParams) ->
  vm = this
  $scope.data = {
    confirmation_code: $stateParams.confirmation_code
  }
  $http.post('api/authenticate/confirm', $scope.data).success((data, status, headers, config) ->
    $auth.setToken(data)
    $state.go 'users'
  ).error (data, status, header, config) ->
    console.log(data);
  return

'use strict'
angular.module('app').controller 'ConfirmController', ConfirmController
