RegisterController = ($scope, $auth, $state, $http, $rootScope) ->
  vm = this

  vm.register = (form)->
    credentials =
      name: vm.user.name
      email: vm.user.email
      password: vm.user.password
    $auth.signup(credentials).then((response) ->
      $state.go 'sign-up-success'
      return
    ).catch (error) ->
      $scope.error = error.data
      if $scope.error.email
        form.email.$setValidity('required', false);
      if $scope.error.password
        form.password.$setValidity('required', false);
      return
    return
  return

'use strict'
angular.module('app').controller 'RegisterController', RegisterController
