'use strict'

###*
 # @ngdoc function
 # @name emilienkoTreeApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the emilienkoTreeApp
###
angular.module 'emilienkoTreeApp'
  .controller 'AboutCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
