(function() {
  var FeedParser, GoogleOauthWrapper, OAuth2, apiKey, app, clientId, clientSecret, express, fs, getEmails, gmail, gmailWrapper, google, http, io, oauth2Client, path, processRequest, redirectUri, returnFirstEmail, scopes, server, url, util;

  express = require('express');

  fs = require('fs');

  path = require('path');

  util = require('util');

  http = require('http');

  io = require('socket.io');

  app = express();

  google = require('googleapis');

  OAuth2 = google.auth.OAuth2;

  gmail = google.gmail('v1');

  url = require('url');

  FeedParser = require('feedparser');

  GoogleOauthWrapper = require('./dist/backEnd/googleOauthWrapper.min');

  apiKey = process.env.GMAIL_API_KEY;

  clientId = process.env.GMAIL_CLIENT_ID;

  clientSecret = process.env.GMAIL_CLIENT_SECRET;

  redirectUri = process.env.GMAIL_REDIRECT_URIS;

  scopes = ['https://www.googleapis.com/auth/gmail.readonly', 'https://www.googleapis.com/auth/gmail.modify', 'https://mail.google.com/mail/feed/atom'];

  oauth2Client = new OAuth2(clientId, clientSecret, redirectUri);

  gmailWrapper = new GoogleOauthWrapper(oauth2Client, scopes);

  app.use(express["static"](__dirname));

  app.set('views', path.join(__dirname, 'views'));

  app.set('view engine', 'ejs');

  app.get('/', function(request, response) {
    url = gmailWrapper.generateAuthUrl();
    return response.redirect(url);
  });

  app.get('/google_response', function(request, response) {
    gmailWrapper.getUserToken(request);
    return response.redirect('/dashboard');
  });

  app.get('/dashboard', function(request, response) {
    return response.render('index', {
      title: 'notification widget'
    });
  });

  getEmails = function(res) {
    console.log("getting emails");
    return gmail.users.messages.list({
      userId: "me",
      maxResults: 10,
      q: "from:hlyjak@8thlight.com",
      auth: oauth2Client
    }, function(err, response) {
      return returnFirstEmail(response.messages, res);
    });
  };

  returnFirstEmail = function(emails, res) {
    return gmail.users.messages.get({
      userId: "me",
      id: emails[0].id,
      auth: oauth2Client
    }, function(err, response) {
      console.log(err);
      console.log(response);
      return res.json(response);
    });
  };

  processRequest = function(url, response) {
    var data, feedParser, feedRequest;
    data = [];
    feedRequest = request(url);
    feedParser = new FeedParser();
    feedRequest.on('response', function(resp) {
      return this.pipe(feedParser);
    });
    feedParser.on('readable', function() {
      var item, _results;
      _results = [];
      while (item = this.read()) {
        _results.push(data.push(item));
      }
      return _results;
    });
    return feedParser.on('end', function() {
      console.log(data[2]);
      return response.send(data);
    });
  };

  server = app.listen(5000, function() {
    return console.log("listening on port " + (server.address().port));
  });

}).call(this);
