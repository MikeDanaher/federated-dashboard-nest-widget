namespace('Notification.Widgets')

class Notification.Widgets.Controller
  constructor: (args) ->
    @container    = args.container
    @refreshRate  = args.refreshRate
    @defaultValue = args.defaultValue
    @display      = new Notification.Widgets.Display(args)
    @processor    = new Notification.Widgets.EmailProcessor(@display, args.maxNotifications)
    @isActive     = false

  initialize: ->
    @display.setup()
    @bind()
    @activate()
    @displayDefault()

  bind: ->
    $("#{@container} [data-name=widget-form]").on('submit',(e) =>
      e.preventDefault()
      @getNotifications(@display.getInput()))
    $("#{@container} [data-name=widget-close]").on('click', => @closeWidget())

  unbind: ->
    $("#{@container} [data-name=widget-form]").unbind('submit')
    $("#{@container} [data-name=widget-close]").unbind('click')

  activate: ->
    @isActive = true

  deactivate: ->
    @isActive = false

  displayDefault: ->
    @getNotifications(@defaultValue) if @defaultValue

  getNotifications: (input) ->
    @processor.getNotifications(input)
    if @refreshRate
      @refreshNotifications(input)

  refreshNotifications: (input) ->
    @clearCurrentTimeout()
    @timeout = setTimeout( =>
      @getNotifications(input) if @isActive
    @refreshSeconds())

  clearCurrentTimeout: ->
    clearTimeout(@timeout) if @timeout

  closeWidget: ->
    $(@container).remove()
    @deactivate()
    @unbind()

  refreshSeconds: ->
    @refreshRate * 1000
