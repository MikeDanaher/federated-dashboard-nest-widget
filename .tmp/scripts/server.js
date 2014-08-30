(function() {
  var OAuth2, apiKey, app, clientId, clientSecret, express, fs, getAccessToken, getEmails, gmail, google, http, io, oauth2Client, path, redirectUri, returnFirstEmail, scopes, server, util;

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

  apiKey = process.env.GMAIL_API_KEY;

  clientId = process.env.GMAIL_CLIENT_ID;

  clientSecret = process.env.GMAIL_CLIENT_SECRET;

  redirectUri = process.env.GMAIL_REDIRECT_URIS;

  scopes = ["https://www.googleapis.com/auth/gmail.readonly", "https://www.googleapis.com/auth/gmail.modify"];

  oauth2Client = new OAuth2(clientId, clientSecret, redirectUri);

  app.use(express["static"](__dirname));

  app.set('views', path.join(__dirname, 'views'));

  app.set('view engine', 'ejs');

  app.get('/', function(request, response) {
    var bodyChunks, options, req;
    options = {
      host: 'api.meetup.com',
      path: '/Chicago-Agile-Open-Space/upcoming.ical'
    };
    bodyChunks = [];
    req = http.get(options, function(res) {
      return res.on('data', function(chunk) {
        return bodyChunks.push(chunk);
      }).on('end', function() {
        var body;
        body = Buffer.concat(bodyChunks);
        console.log(body);
        return response.json({
          body: body.toString()
        });
      });
    });
    return req.on('error', function(error) {
      return console.log(error);
    });
  });

  app.get('/emails', function(request, response) {
    return getAccessToken(oauth2Client, response);
  });

  app.get('/google_response', function(request, response) {
    var code;
    code = request.query.code;
    return oauth2Client.getToken(code, function(err, tokens) {
      oauth2Client.setCredentials(tokens);
      if (err) {
        return console.log(err);
      } else {
        console.log('got token:');
        console.log(tokens);
        return getEmails(response);
      }
    });
  });

  getAccessToken = function(oauth2Client, response) {
    var url;
    url = oauth2Client.generateAuthUrl({
      access_type: 'offline',
      scope: scopes
    });
    return response.redirect(url);
  };

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

  server = app.listen(5000, function() {
    return console.log("listening on port " + (server.address().port));
  });

}).call(this);
