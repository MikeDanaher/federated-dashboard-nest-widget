namespace('Notification.Widgets')

class Notification.Widgets.Controller
  constructor: (args) ->
    @container = args.container
    @display   = new Notification.Widgets.Display(args)
    @processor = new Notification.Widgets.EmailProcessor(@display, args.maxNotifications)

  initialize: ->
    @display.setup()
    @bind()

  bind: ->
    $("#{@container} [data-id=notification-button]").on('click',  => @getNotifications())

  getNotifications: ->
    searchFrom = @display.getInput()
    @processor.getNotifications(searchFrom)
