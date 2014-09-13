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
url = require('url')
FeedParser = require('feedparser')
GoogleOauthWrapper = require('./dist/backEnd/googleOauthWrapper.min')

apiKey        = process.env.GMAIL_API_KEY
clientId      = process.env.GMAIL_CLIENT_ID
clientSecret  = process.env.GMAIL_CLIENT_SECRET
redirectUri   = process.env.GMAIL_REDIRECT_URIS

scopes  = [ 'https://www.googleapis.com/auth/gmail.readonly',
            'https://www.googleapis.com/auth/gmail.modify',
            'https://mail.google.com/mail/feed/atom' ]

oauth2Client = new OAuth2(clientId, clientSecret, redirectUri)
gmailWrapper = new GoogleOauthWrapper(oauth2Client, scopes)

app.use(express.static(__dirname))
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'ejs')

app.get '/', (request, response) ->
  url = gmailWrapper.generateAuthUrl()
  response.redirect(url)

app.get '/google_response', (request, response) ->
  gmailWrapper.getUserToken(request)
  response.redirect('/dashboard')

app.get '/dashboard', (request, response) ->
  response.render 'index', {title: 'notification widget'}


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

processRequest = (url, response) ->
  data = []
  feedRequest = request(url)
  feedParser = new FeedParser()
  feedRequest.on('response', (resp) ->
    this.pipe(feedParser)
  )

  feedParser.on('readable', ->
    data.push(item) while item = this.read()
  )

  feedParser.on('end', ->
    console.log data[2]
    response.send(data)
  )

server = app.listen 5000, ->
  console.log "listening on port #{server.address().port}"
