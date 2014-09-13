class GoogleOauthWrapper
  constructor: (oauthClient, scopes) ->
    @oauthClient = oauthClient
    @scopes = scopes

  generateAuthUrl: ->
    @oauthClient.generateAuthUrl({
      access_type: 'offline',
      scope:      @scopes
    })

  getUserToken: (request) ->
    @oauthClient.getToken(
      @codeFromRequest(request),
      (err, token) =>
        if err
          @error(err)
        else
          @setCredentials(token)
      )

  codeFromRequest: (request) ->
    request.query.code

  setCredentials: (tokens) ->
    @oauthClient.setCredentials(tokens)

  error: (err) ->
    console.log(err)


module.exports = GoogleOauthWrapper
