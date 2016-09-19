RestorePasswordController = ($scope, $auth, $state, $http, $rootScope, $stateParams) ->
  vm = this
  $scope.minlength = 8

  $scope.restorePassword = (form) ->
    $scope.data = {
      restore_password_code: $stateParams.restore_password_code
      password: $scope.password
    }
    console.log($scope.data);
    $scope.passwordErrorConfirm = false
    if $scope.password != $scope.confirmPassword
      $scope.passwordError = 'Пароли должны совпадать'
      return false

    if !form.password.$valid
      $scope.passwordError = 'Минимальная длина пароля - 8 символов'
      return false

    $http.post('api/authenticate/restore_password', $scope.data).success((data, status, headers, config) ->
      console.log(data);
      if(data)
        $scope.successRestorePassword = true
      # $auth.setToken(data)
      # $state.go 'users'
    ).error (data, status, header, config) ->
      console.log(data);
    return

'use strict'
angular.module('app').controller 'RestorePasswordController', RestorePasswordController
