namespace('Notification.Widgets')

class Notification.Widgets.EmailPresenter
  constructor: (email) ->
    @id      = email.id
    @from    = email.from
    @body    = email.body
    @subject = email.subject
    @symbol  = @generateSymbol(email.subject)

  generateSymbol: (subject) ->
    if subject == '[alert]'
      '<i class="red fa fa-exclamation-circle"></i>'
    else
      '<i class="fa fa-bell"></i>'
