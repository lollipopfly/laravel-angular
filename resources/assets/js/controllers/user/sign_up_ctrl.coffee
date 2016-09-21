SignUpController = ($auth, $state) ->
  vm = this

  vm.register = (form)->
    credentials =
      name: vm.user.name
      email: vm.user.email
      password: vm.user.password

    $auth.signup(credentials).then((response) ->
      $state.go 'sign_up_success'
      return
    ).catch (error) ->
      vm.error = error.data
      if vm.error.email
        form.email.$setValidity('required', false);
      if vm.error.password
        form.password.$setValidity('required', false);
      return
    return
  return

'use strict'
angular
  .module('app')
  .controller('SignUpController', SignUpController)