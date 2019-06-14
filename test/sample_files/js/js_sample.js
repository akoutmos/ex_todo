// FIXME: Don't do anything CPU bound and block the event loop
// TODO: Watch https://www.youtube.com/watch?v=JvBT4XBdoUE to see why the BEAM is awesome

const http = require('http')

http
  .createServer(function(req, res) {
    res.end('hello world!')
  })
  .listen(9000)

console.log('Server listening on port 9000')
