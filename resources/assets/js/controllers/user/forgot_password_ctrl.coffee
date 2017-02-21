ForgotPasswordController = ($http) ->
  vm = this

  vm.restorePassword = ()->
    data = {
      email: vm.email
    }

    $http.post('api/authenticate/send_reset_code', data)
      .then (response) ->
        if(response.data)
          vm.successSendingEmail = true
      , (error) ->
        vm.emailErrorText = error.data.error

    return

  return

'use strict'
angular
  .module('app')
  .controller('ForgotPasswordController', ForgotPasswordController)
