buffer = require 'buffer'
crypto = require 'crypto'
cookie = require 'cookie'

class RackSession
  constructor: (config) ->
    @secret = config.secret
    @key = config.key || 'rack.session'

  findSession: (cookieHeader, callback) ->
    unless callback
      return

    unless cookieHeader
      return callback 'Cookie header missing'

    rackSessionCookie = @findRackSessionCookie cookieHeader
    unless rackSessionCookie
      return callback 'Rack session cookie missing'

    [b64value, hexDigest] = @getValueAndDigest rackSessionCookie
    unless b64value && hexDigest
      return callback 'Invalid Rake session cookie'

    digest = @generateHmac b64value, @secret
    unless digest == hexDigest
      return callback "Digests differ: calculated=#{digest}, requested=#{b64digest}"

    sessionObject = @decodeSessionObject b64value
    unless sessionObject
      return callback 'Failed to parse Rack session cookie'

    callback null, sessionObject

  findRackSessionCookie: (cookieHeader) ->
    cookies = cookie.parse cookieHeader
    cookies[@key]

  getValueAndDigest: (rackCookie) ->
    rackCookie.split '--'

  generateHmac: (data, secret) ->
    hmac = crypto.createHmac 'sha1', secret
    hmac.update data
    hmac.digest 'hex'

  decodeSessionObject: (b64value) ->
    try
      @deserialize new Buffer b64value, 'base64'
    catch e
      null

  deserialize: (buffer) ->
    JSON.parse buffer.toString 'utf8'


module.exports =
  RackSession: RackSession
