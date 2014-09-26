namespace('Notification')

class Notification.Controller
  @settings = {}
  @setupWidgetIn: (settings) ->
    new Notification.Widgets.Controller(settings).initialize()
    @settings = settings

  @exitEditMode: ->
    $('[data-id=notification-widget-wrapper] [data-id=notification-form]').hide(@animationSpeed())
    $('[data-id=notification-widget-wrapper] .widget-close').hide(@animationSpeed())

  @enterEditMode: ->
    console.log @animationSpeed()
    $('[data-id=notification-widget-wrapper] [data-id=notification-form]').show(@animationSpeed())
    $('[data-id=notification-widget-wrapper] .widget-close').show(@animationSpeed())

  @animationSpeed: ->
    @settings.animationSpeed
