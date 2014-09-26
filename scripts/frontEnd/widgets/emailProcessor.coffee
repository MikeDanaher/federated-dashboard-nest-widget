namespace('Notification.Widgets')

class Notification.Widgets.EmailProcessor
  constructor: (display, maxNotifications) ->
    @display = display
    @maxNotifications = maxNotifications
    @currentNotifications = []
    @notificationsHistory = []

  getNotifications: (from) ->
    Notification.Widgets.API.getEmailsFrom(@, from)

  processEmails: (emails) ->
    _.each(emails.reverse(), (email) =>
      if @isNewEmail(email)
        @getNewEmail(email)
    )

  isNewEmail: (email) ->
    isNewEmail = true
    _.each(@notificationsHistory, (existingEmail) ->
      if existingEmail.id == email.id
        isNewEmail = false
    )
    isNewEmail

  getNewEmail: (email) ->
    Notification.Widgets.API.getEmail(email.id, @)

  processEmail: (email) ->
    @addToHistory(email)
    if email.body && @hasValidSubject(email)
      @displayEmail(email)

  hasValidSubject: (email) ->
    email.subject && (email.subject == '[notification]' || email.subject == '[alert]')

  displayEmail: (email) ->
    @addToCurrentNotifications(email)
    @display.renderEmails(@recentEmails())

  addToHistory: (email) ->
    @addToBegining(@notificationsHistory, email)

  addToCurrentNotifications: (email) ->
    @addToBegining(@currentNotifications, @createPresenter(email))

  createPresenter: (email) ->
    new Notification.Widgets.EmailPresenter(email)

  addToBegining: (container, element) ->
    container.unshift(element)

  recentEmails: ->
    @currentNotifications.slice(0, @maxNotifications)
