namespace('Notification')

class Notification.Controller
  @setupWidgetIn: (settings) ->
    templateHtml = Notification.Templates.renderForm()
    $(settings.container).html(templateHtml)
    @bind()

  @bind: ->
    $('[data-id=notification-button]').click( (event) =>
      console.log 'clicked'
      event.preventDefault()
      @getEmails()
    )

  @getEmails: ->
    $.post('/get_emails', {}, (response) ->
      console.log response
    )

  @exitEditMode: ->
    $('[data-id=notification-form]').hide()
    $('.widget-close').hide()

  @enterEditMode: ->
    $('[data-id=notification-form]').show()
    $('.widget-close').show()
