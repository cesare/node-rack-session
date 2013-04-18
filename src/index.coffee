{RackSession} = require './RackSession'

socketioAuthorization = (config, fn) ->
  self = this
  rack = new RackSession config

  (handshake, callback) ->
    rack.findSession handshake.headers.cookie, (error, sessionObject) =>
      if error
        return callback "Authorization failed", false

      handshake.rackSession = sessionObject

      if fn
        fn.call this, handshake, sessionObject, callback
      else
        callback null, true

module.exports =
  socketioAuthorization: socketioAuthorization
