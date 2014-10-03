namespace('Notification.Widgets')

class Notification.Widgets.API
  @getEmailsFrom: (processor, from) ->
    $.get "/emails?from=#{ from || '*@8thlight.com' }", (response) ->
      processor.processEmails(response)

  @getEmail: (id, processor) ->
    $.get "/emails/#{id}", (response) ->
      processor.processEmail(response)

