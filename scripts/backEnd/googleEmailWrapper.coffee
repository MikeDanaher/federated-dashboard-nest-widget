base64 = require('base64')

class GoogleEmailWrapper
  constructor: (args) ->
    @maxResults = args['maxResults'] || 5
    @auth       = args['auth']
    @resource   = args['resource']

  getEmailsFrom: (receiver, callback) ->
    @resource.list({
      userId:     'me',
      maxResults: @maxResults,
      q:          "from:#{receiver}",
      auth:       @auth
    }, (err, response)  =>
      @respondMessages(err, response, callback)
    )

  respondMessages: (err, response, callback) ->
    if err
      callback(err)
    else
      callback(response.messages)

  getFormatedEmailById: (id, callback) ->
    @getEmailById(id, (err, response) =>
      @respondFormatedEmail(err, response, callback)
    )

  getEmailById: (id, callback) ->
    @resource.get({
      userId: 'me',
      id:     id,
      auth:   @auth
    }, (err, response) =>
      callback(err, response)
    )

  respondFormatedEmail: (err, response, callback) ->
    if err
      callback(err)
    else
      callback(@formatEmail(response.payload))

  formatEmail: (emailData) ->
    {
      from:    @emailSender(emailData.headers),
      subject: @emailSubject(emailData.headers)
      body:    @decodeEmailBody(emailData.body)
    }

  emailSender: (headers) ->
    @getHeaderValue('From', headers)

  emailSubject: (headers) ->
    @getHeaderValue('Subject', headers)

  decodeEmailBody: (body) ->
    base64.decode(body.data)

  getHeaderValue: (headerName, headers) ->
    match = headers.filter((header) ->
      header.name == headerName
    )
    match[0].value

module.exports = GoogleEmailWrapper
