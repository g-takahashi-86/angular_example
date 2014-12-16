# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

angularExample = angular.module('angularExample', ['ngResource'])

angularExample.factory 'User', ['$resource', ($resource) ->
  return $resource 'users/:id.json', {}, {
    query: {method:'GET', params:{id: @id}, isArray:true}
  }
]

angularExample.controller 'UserController', ($scope, User) ->
  $scope.users = User.query()
