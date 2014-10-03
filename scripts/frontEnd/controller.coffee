namespace('Notification')

class Notification.Controller
  @setupWidgetIn: (settings) ->
    new Notification.Widgets.Controller(settings).initialize()
