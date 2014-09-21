(function() {
  var FeedParser, GoogleEmailWrapper, GoogleOauthWrapper, OAuth2, apiKey, app, clientId, clientSecret, emailWrapper, express, getEmails, gmail, google, io, oauth2Client, oauthWrapper, path, redirectUri, returnFirstEmail, scopes, server;

  express = require('express');

  app = express();

  path = require('path');

  google = require('googleapis');

  OAuth2 = google.auth.OAuth2;

  gmail = google.gmail('v1');

  io = require('socket.io');

  FeedParser = require('feedparser');

  GoogleOauthWrapper = require('./dist/backEnd/googleOauthWrapper.min');

  GoogleEmailWrapper = require('./dist/backend/googleEmailWrapper.min');

  apiKey = process.env.GMAIL_API_KEY;

  clientId = process.env.GMAIL_CLIENT_ID;

  clientSecret = process.env.GMAIL_CLIENT_SECRET;

  redirectUri = process.env.GMAIL_REDIRECT_URIS;

  scopes = ['https://www.googleapis.com/auth/gmail.readonly', 'https://www.googleapis.com/auth/gmail.modify', 'https://mail.google.com/mail/feed/atom'];

  oauth2Client = new OAuth2(clientId, clientSecret, redirectUri);

  oauthWrapper = new GoogleOauthWrapper(oauth2Client, scopes);

  emailWrapper = new GoogleEmailWrapper({
    auth: oauth2Client,
    resource: gmail.users.messages
  });

  app.use(express["static"](__dirname));

  app.set('views', path.join(__dirname, 'views'));

  app.set('view engine', 'ejs');

  app.get('/', function(request, response) {
    var url;
    url = oauthWrapper.generateAuthUrl();
    return response.redirect(url);
  });

  app.get('/google_response', function(request, response) {
    oauthWrapper.getUserToken(request);
    return response.redirect('/dashboard');
  });

  app.get('/dashboard', function(request, response) {
    return response.render('index', {
      title: 'notification widget'
    });
  });

  app.post('/get_emails', function(request, response) {
    return getEmails(response);
  });

  getEmails = function(res) {
    console.log("getting emails");
    return emailWrapper.getEmailsFrom('*@gmail.com', function(response) {
      return returnFirstEmail(response, res);
    });
  };

  returnFirstEmail = function(emails, res) {
    console.log(emails[0].id);
    return emailWrapper.getFormatedEmailById(emails[0].id, function(response) {
      console.log(response);
      return res.json(response);
    });
  };

  server = app.listen(5000, function() {
    return console.log("listening on port " + (server.address().port));
  });

}).call(this);
