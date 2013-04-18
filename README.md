rack-session
=====

rack-session enables to share session attributes among the Rack web application (such as Sinatra, Padrino and Rails) and the node application (Express, Socket.IO, and so on).

### Installation

  $ npm install rack-session

### Example

```javascript
var socketioAuthorization = require('rack-session').socketioAuthorization;

var config = {
  key: 'rack.session',
  secret: 'YOUR-SESSION-SECRET'
};

var io = require('socket.io').listen(3000);

// create authorization function
io.set('authorization', socketioAuthorization(config, function(handshake, session, callback) {
  this.log.debug(session);
  callback(null, true);
}));

io.sockets.on('connection', function(socket) {
  socket.emit('connection', 'ok!');
});

```
