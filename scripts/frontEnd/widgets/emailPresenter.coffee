namespace('Notification.Widgets')

class Notification.Widgets.EmailPresenter
  constructor: (email) ->
    @id      = email.id
    @from    = email.from
    @subject = email.subject
    @symbol  = @generateSymbol(email.subject)
    @body    = @generateBody(email.subject)

  generateSymbol: (subject) ->
    if @contains(subject, '[alert]')
      '<i class="red fa fa-exclamation-circle"></i>'
    else
      '<i class="fa fa-bell"></i>'

  contains: (checkStr, substr) ->
    checkStr.indexOf(substr) != -1

  generateBody: (subject) ->
    rawBody = subject.split('] ')[1]
    @sanitizeBody(rawBody)

  sanitizeBody: (body) ->
    _.each(@charactersToEscape, (escapedVersion, char) =>
      body = body.replace(char, escapedVersion) while body.indexOf(char) != -1
    )
    body

  charactersToEscape: {
    '<' : '&lt;'
    '>' : '&gt;'
    '\"': '&quot;'
  }
