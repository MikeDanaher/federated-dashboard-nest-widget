(function() {
  var GoogleOauthWrapper;

  GoogleOauthWrapper = (function() {
    function GoogleOauthWrapper(oauthClient, scopes) {
      this.oauthClient = oauthClient;
      this.scopes = scopes;
    }

    GoogleOauthWrapper.prototype.generateAuthUrl = function() {
      return this.oauthClient.generateAuthUrl({
        access_type: 'offline',
        scope: this.scopes
      });
    };

    GoogleOauthWrapper.prototype.getUserToken = function(request) {
      return this.oauthClient.getToken(this.codeFromRequest(request), (function(_this) {
        return function(err, token) {
          if (err) {
            return _this.error(err);
          } else {
            return _this.setCredentials(token);
          }
        };
      })(this));
    };

    GoogleOauthWrapper.prototype.codeFromRequest = function(request) {
      return request.query.code;
    };

    GoogleOauthWrapper.prototype.setCredentials = function(tokens) {
      return this.oauthClient.setCredentials(tokens);
    };

    GoogleOauthWrapper.prototype.error = function(err) {
      return console.log(err);
    };

    return GoogleOauthWrapper;

  })();

  module.exports = GoogleOauthWrapper;

}).call(this);
