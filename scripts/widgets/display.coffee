namespace('Notification.Widgets')

class Notification.Widgets.Display
  constructor: (args) ->
    @container = args.container

  setup: ->
    templateHtml = Notification.Widgets.Templates.renderForm()
    $(@container).html(templateHtml)

  getInput: ->
    $("#{@container} [name=widget-input]").val()

  renderEmails: (emails) ->
    emailsHtml = Notification.Widgets.Templates.renderEmails(emails)
    $("#{@container} [data-name=widget-output]").html(emailsHtml)
