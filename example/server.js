(function() {
  var Twitter, app, express, fs, path, server, twit, util;

  express = require('express');

  fs = require('fs');

  path = require('path');

  util = require('util');

  Twitter = require('./bower_components/twitter-widget/dist/backend_module');

  app = express();

  twit = Twitter.setupAuthenticationObject();

  app.use(express["static"](__dirname));

  app.set('views', path.join(__dirname, 'views'));

  app.set('view engine', 'ejs');

  app.get('/search_twitter/:search_for', function(request, response) {
    var searchFor, searchKey;
    searchFor = request.params.search_for;
    searchKey = Twitter.getSearchFormat(searchFor);
    return twit.search(searchKey, {
      count: 5,
      result_type: 'recent'
    }, function(data) {
      data.statuses;
      return response.send(data.statuses);
    });
  });

  app.get('/', function(request, response) {
    return response.render('index', {
      title: "Twitter Widget"
    });
  });

  server = app.listen(5000, function() {
    return console.log("listening on port " + (server.address().port));
  });

}).call(this);
