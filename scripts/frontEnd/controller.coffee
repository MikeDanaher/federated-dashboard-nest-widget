namespace('Notification')

class Notification.Controller
  @setupWidgetIn: (settings) ->
    templateHtml = Notification.Templates.renderForm()
    $(settings.container).html(templateHtml)

  @exitEditMode: ->
    $('[data-id=notification-form]').hide()
    $('.widget-close').hide()

  @enterEditMode: ->
    $('[data-id=notification-form]').show()
    $('.widget-close').show()
