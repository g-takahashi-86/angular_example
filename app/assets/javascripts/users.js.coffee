# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#
# Angularアプリの設定
#
angularExample = angular.module('angularExample', ['ngResource'])

#
# Angularがturbolinksの影響で画面遷移後に発動しない場合があるのを解決する
#
$(document).on('ready page:load', ->
  angular.bootstrap(document.body, ['angularExample'])
)

#
# Angularを使ってリクエストを送った時にcsrf-tokenが正常に送られない件を解決する
#
angularExample.config ($httpProvider) ->
  authToken = angular.element('meta[name="csrf-token"]').attr("content");
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
  $httpProvider.defaults.headers.common["X-Requested-With"] = "XMLHttpRequest";

#
# /usersへのアクセスをするリソースを定義
#
angularExample.factory 'User', ['$resource', ($resource) ->
  return $resource 'users/:id.json', {}, {
    query: {method:'GET', params:{id: @id}, isArray:true},
    remove: {method: 'DELETE', params:{id: @id}, url: 'users/:id', withCredentials: true}}]

#
# /users配下で動くコントローラーを定義
#
angularExample.controller 'UserController', ($scope, User) ->
  # デフォルトのページ番号を設定
  $scope.page = window.page || 1;

  # ボタンをdisableにするときに使用
  $scope.buttonDisabled = true;

  # クエリを投げるときにページパラメータを送信
  $scope.users = User.query({page: $scope.page})

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
