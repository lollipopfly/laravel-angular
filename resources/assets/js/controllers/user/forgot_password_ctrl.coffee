ForgotPasswordController = ($scope, $auth, $state, $http, $rootScope, $stateParams) ->
  vm = this

  $scope.restorePassword = (form) ->
    $scope.data = {
      email: $scope.email
    }

    $http.post('api/authenticate/send_restore_code', $scope.data).success((data, status, headers, config) ->
      console.log(data);
      if(data)
        $scope.successSendingEmail = true
    ).error (data, status, header, config) ->
      console.log(data);
      $scope.emailErrorText = data.error
    return

'use strict'
angular.module('app').controller 'ForgotPasswordController', ForgotPasswordController
