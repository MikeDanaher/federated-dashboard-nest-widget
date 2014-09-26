GoogleOauthWrapper = require('./googleOauthWrapper')
GoogleEmailWrapper = require('./googleEmailWrapper')
google             = require('googleapis')
OAuth2             = google.auth.OAuth2
gmail              = google.gmail('v1')

scopes  = [ 'https://www.googleapis.com/auth/gmail.readonly',
            'https://www.googleapis.com/auth/gmail.modify',
            'https://mail.google.com/mail/feed/atom' ]

apiKey        = process.env.GMAIL_API_KEY
clientId      = process.env.GMAIL_CLIENT_ID
clientSecret  = process.env.GMAIL_CLIENT_SECRET
redirectUri   = process.env.GMAIL_REDIRECT_URIS

oauth2Client = new OAuth2(clientId, clientSecret, redirectUri)
oauthWrapper = new GoogleOauthWrapper(oauth2Client, scopes)
emailWrapper = new GoogleEmailWrapper({
  auth:     oauth2Client,
  resource: gmail.users.messages
  maxResults: 10
})

exports.getPermission = (req, res) ->
  url = oauthWrapper.generateAuthUrl()
  res.redirect(url)

exports.googleRedirect = (req, res) ->
  oauthWrapper.getUserToken(req)

exports.getEmails = (req, res) ->
  from = req.query.from
  emailWrapper.getEmailsFrom(from, (response) ->
    res.json response
  )

exports.getEmail = (req, res) ->
  id = req.params.id
  emailWrapper.getFormatedEmailById(id, (response) ->
    res.json response
  )
