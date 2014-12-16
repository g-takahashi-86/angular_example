# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

angularExample = angular.module('angularExample', ['ngResource'])

$(document).on('ready page:load', ->
  angular.bootstrap(document.body, ['angularExample'])
)

angularExample.config ($httpProvider) ->
  authToken = angular.element('meta[name="csrf-token"]').attr("content");
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
  $httpProvider.defaults.headers.common["X-Requested-With"] = "XMLHttpRequest";

angularExample.factory 'User', ['$resource', ($resource) ->
  return $resource 'users/:id.json', {}, {
    query: {method:'GET', params:{id: @id}, isArray:true},
    remove: {method: 'DELETE', params:{id: @id}, url: 'users/:id', withCredentials: true}}]

angularExample.controller 'UserController', ($scope, User) ->
  $scope.users = User.query()
  $scope.buttonDisabled = true;

  #
  # 削除に対するアクション
  #
  $scope.deleteButton = (index) ->
    if !confirm("本当にキャンセルしてよいですか？")
      return

    user = $scope.users[index]

    user.$remove({id: user.id})

    $scope.users.splice(index, 1)

    $scope.buttonDisabled = true;
