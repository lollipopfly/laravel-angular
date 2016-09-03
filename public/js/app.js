(function() {

    'use strict';

    angular
        .module('authApp', ['ui.router', 'satellizer'])
        .config(function($stateProvider, $urlRouterProvider, $authProvider, $locationProvider) {

            $locationProvider.html5Mode(true);
            // Satellizer configuration that specifies which API
            // route the JWT should be retrieved from
            $authProvider.loginUrl = '/authenticate';

            // Redirect to the auth state if any other states
            // are requested other than users
            $urlRouterProvider.otherwise('/');

            $stateProvider
                .state('auth', {
                    url: '/',
                    templateUrl: '../views/authView.html',
                    controller: 'AuthController as auth'
                })
                .state('test', {
                    url: '/test',
                    templateUrl: '../views/test.html',
                })
                .state('test1', {
                    url: '/test1',
                    templateUrl: '../views/test1.html',
                })
                .state('users', {
                    url: '/users',
                    templateUrl: '../views/userView.html',
                    controller: 'UserController as user'
                });
        });
})();