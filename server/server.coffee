express     = require('express')
app         = express()
path        = require('path')
gmailRouter = require('./dist/backend/router')

io          = require('socket.io')

app.use(express.static(__dirname))
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'ejs')

app.get '/', gmailRouter.getPermission
app.get '/emails', gmailRouter.getEmails
app.get '/emails/:id', gmailRouter.getEmail
app.get '/google_response', (request, response) ->
  gmailRouter.googleRedirect(request, response)
  response.redirect('/dashboard')

app.get '/dashboard', (request, response) ->
  response.render 'index', {title: 'notification widget'}

server = app.listen 5000, ->
  console.log "listening on port #{server.address().port}"
