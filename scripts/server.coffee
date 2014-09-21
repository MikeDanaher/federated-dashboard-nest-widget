express = require('express')
app     = express()
path    = require('path')
google  = require('googleapis')
OAuth2  = google.auth.OAuth2
gmail   = google.gmail('v1')

io      = require('socket.io')

FeedParser = require('feedparser')
GoogleOauthWrapper = require('./dist/backEnd/googleOauthWrapper.min')
GoogleEmailWrapper = require('./dist/backend/googleEmailWrapper.min')

apiKey        = process.env.GMAIL_API_KEY
clientId      = process.env.GMAIL_CLIENT_ID
clientSecret  = process.env.GMAIL_CLIENT_SECRET
redirectUri   = process.env.GMAIL_REDIRECT_URIS

scopes  = [ 'https://www.googleapis.com/auth/gmail.readonly',
            'https://www.googleapis.com/auth/gmail.modify',
            'https://mail.google.com/mail/feed/atom' ]

oauth2Client = new OAuth2(clientId, clientSecret, redirectUri)
oauthWrapper = new GoogleOauthWrapper(oauth2Client, scopes)
emailWrapper = new GoogleEmailWrapper({
  auth:     oauth2Client,
  resource: gmail.users.messages
})

app.use(express.static(__dirname))
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'ejs')

app.get '/', (request, response) ->
  url = oauthWrapper.generateAuthUrl()
  response.redirect(url)

app.get '/google_response', (request, response) ->
  oauthWrapper.getUserToken(request)
  response.redirect('/dashboard')

app.get '/dashboard', (request, response) ->
  response.render 'index', {title: 'notification widget'}

app.post '/get_emails', (request, response) ->
  getEmails(response)

getEmails = (res) ->
  console.log "getting emails"
  emailWrapper.getEmailsFrom('*@gmail.com', (response) ->
    returnFirstEmail(response, res)
  )

returnFirstEmail = (emails, res) ->
  console.log emails[0].id
  emailWrapper.getFormatedEmailById(emails[0].id, (response) ->
    console.log response
    res.json response
  )

server = app.listen 5000, ->
  console.log "listening on port #{server.address().port}"
