express = require('express')
fs      = require('fs')
path    = require('path')
util    = require('util')
http    = require('http')
io      = require('socket.io')
app     = express()
google  = require('googleapis')
OAuth2  = google.auth.OAuth2
gmail   = google.gmail('v1')

apiKey        = process.env.GMAIL_API_KEY
clientId      = process.env.GMAIL_CLIENT_ID
clientSecret  = process.env.GMAIL_CLIENT_SECRET
redirectUri   = process.env.GMAIL_REDIRECT_URIS

scopes  = ["https://www.googleapis.com/auth/gmail.readonly",
           "https://www.googleapis.com/auth/gmail.modify"]

oauth2Client = new OAuth2(clientId, clientSecret, redirectUri)

app.use(express.static(__dirname))
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'ejs')

app.get '/', (request, response) ->
  options = {
    host: 'api.meetup.com'
    path: '/Chicago-Agile-Open-Space/upcoming.ical'
  }
  bodyChunks = []
  req = http.get(options, (res) ->
    res.on('data', (chunk) ->
      bodyChunks.push(chunk)
    ).on('end', ->
      body = Buffer.concat(bodyChunks)
      console.log body
      response.json {body: body.toString()}
    )
  )
  req.on('error', (error) ->
    console.log error
  )
  #response.render 'index', {title: "gmail-widget"}

app.get '/emails', (request, response) ->
  getAccessToken(oauth2Client, response)

app.get '/google_response', (request, response) ->
  code = request.query.code
  oauth2Client.getToken(code, (err, tokens) ->
    oauth2Client.setCredentials(tokens)
    if err
      console.log err
    else
      console.log 'got token:'
      console.log tokens
      getEmails(response)
  )


getAccessToken = (oauth2Client, response) ->
  url = oauth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: scopes
  })

  response.redirect(url)

getEmails = (res) ->
  console.log "getting emails"
  gmail.users.messages.list({
    userId: "me",
    maxResults: 10,
    q: "from:hlyjak@8thlight.com"
    auth: oauth2Client
  }, (err, response) ->
    returnFirstEmail(response.messages, res)
  )

returnFirstEmail = (emails, res) ->
  gmail.users.messages.get({
    userId: "me",
    id: emails[0].id,
    auth: oauth2Client
  }, (err, response) ->
    console.log err
    console.log response
    res.json response
  )

server = app.listen 5000, ->
  console.log "listening on port #{server.address().port}"
