ResetPasswordController = ($http, $stateParams) ->
  vm = this
  vm.minlength = 8

  vm.restorePassword = (form) ->
    data = {
      reset_password_code: $stateParams.reset_password_code
      password: vm.password
    }

    if vm.password != vm.confirmPassword
      vm.passwordError = 'Password is invalid! Password doesn\'t match confirmation'

      return false

    if !form.password.$valid
      vm.passwordError = 'Password is invalid! Minimum length is 8 characters'

      return false

    $http.post('api/authenticate/reset_password', data)
      .then (response) ->
        if(response.data)
           vm.successRestorePassword = true
      , (error) ->
        console.log(error);

    return

  return

'use strict'
angular
  .module('app')
  .controller('ResetPasswordController', ResetPasswordController)
