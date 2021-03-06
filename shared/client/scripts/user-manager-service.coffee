﻿exports.name = 'UserManagerService'

exports.inject = (app) ->
  app.service exports.name, [
    '$http'
    '$q'
    '$location'
    'authRequiredInterceptor'
    'ButtonsOnlyModalFactory'
    exports.service
  ]
  exports.service

exports.service = ($http, $q, $location, authRequiredInterceptor, ButtonsOnlyModalFactory) ->
  user_api_uri = '/api/users'

  class UserManagerService
    get_current_user: ->
      return $q (resolve, reject) ->
        $http.get(user_api_uri + '/current')
        .success (current_user, status, headers, config) ->
          resolve current_user
          return
        .error (data, status, headers, config) ->
          reject()
          return
        return

    change_workspace_path: (user, path) ->
      $q (resolve, reject) ->
        $http.put(user_api_uri + '/' + user, {preferences: {workspace: {path: path}}})
        .success -> resolve()
        .error (data, status) -> reject(status)

    login: (username, password) ->
      return $q (resolve, reject) ->
        $http.post('/login', { username: username, password: password })
        .success (data, status, headers, config) ->
          if authRequiredInterceptor.last_intercepted_path?
            $location.path authRequiredInterceptor.last_intercepted_path
            resolve()
          else
            $location.path '/'
            resolve()
        .error (data, status, headers, config) ->
          reject()
          return
        return

    logout: ->
      return $q (resolve, reject) ->
        $http.post('/logout')
        .success (data, status, headers, config) ->
            resolve()
        .error (data, status, headers, config) ->
          reject()
          return
        return

  return new UserManagerService