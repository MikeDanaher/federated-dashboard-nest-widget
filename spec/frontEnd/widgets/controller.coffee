describe 'Notificatoin.Widgets.Controller', ->
  mockEmails = [{ id: '1' }, { id: '2' }]
  email = 'test@test.com'

  getResponse = (response) ->
    JSON.stringify(response)

  controller = undefined

  newController = (container, defaultValue) ->
    new Notification.Widgets.Controller({ container: container, defaultValue: defaultValue })

  setupController = ->
    setFixtures sandbox()
    controller = newController('#sandbox')
    controller.initialize()

  describe '#initialize', ->
    it 'executes widget setup', ->
      setupController()
      expect($('.widget-form')).toContainElement('button')

    it 'binds the notification button to the get notifications method', ->
      setupController()
      spy = spyOn(Notification.Widgets.API, 'getEmailsFrom')
      $('[name=notification-search]').val(email)
      $('[data-id=notification-button]').click()

      expect(spy).toHaveBeenCalledWith(controller.processor, email)


    it 'binds the click close button to the closeWidget method', ->
      setupController()

      expect($('#sandbox')).toBeInDOM()
      $('[data-id=notification-close]').click()

      expect($('#sandbox')).not.toBeInDOM()

    it 'sets the widget as active', ->
      controller = newController('#sandbox')

      expect(controller.isActive).toBe(false)
      controller.initialize()

      expect(controller.isActive).toBe(true)

    it 'displays the default value when it is set', ->
      controller = newController('#sandbox', email)

      spy = spyOn(controller.processor, 'getNotifications')
      controller.initialize()

      expect(spy).toHaveBeenCalledWith(email)

  describe '#closeWidget', ->
    it 'is deactivating the widget', ->
      controller = newController('#sandbox')
      controller.activate()

      expect(controller.isActive).toBe(true)
      controller.closeWidget()

      expect(controller.isActive).toBe(false)

    it 'is unbinding itself', ->
      controller = newController('#sandbox')
      controller.activate()
      spyOn(controller, 'unbind')
      controller.closeWidget()

      expect(controller.unbind).toHaveBeenCalled()

  describe '#refreshRate', ->
    controller = undefined
    spy        = undefined
    oneMinute  = 60 * 1000
    container  = '#sandbox'

    newRefreshController = (container, refreshRate) ->
      new Notification.Widgets.Controller({container: container, refreshRate: refreshRate})

    beforeEach ->
      controller = newRefreshController(container, 50)
      controller.activate()
      spy = spyOn(controller.processor, 'getNotifications')
      jasmine.clock().install()

    afterEach ->
      jasmine.clock().uninstall()

    it 'does NOT refresh when no refreshRate is provided', ->
      controller = newRefreshController(container, undefined)
      controller.activate()
      spy = spyOn(controller.processor, 'getNotifications')
      controller.getNotifications(email)
      expect(spy.calls.count()).toBe(1)

      jasmine.clock().tick(oneMinute)
      expect(spy.calls.count()).toBe(1)

    it 'refresh when refreshRate is provided', ->
      controller.getNotifications(email)

      expect(spy.calls.count()).toBe(1)

      jasmine.clock().tick(oneMinute)
      expect(spy.calls.count()).toBe(2)

    it 'does not refresh if the widget is closed', ->
      controller.getNotifications(email)
      expect(spy.calls.count()).toBe(1)

      controller.deactivate()
      jasmine.clock().tick(oneMinute)

      expect(spy.calls.count()).toBe(1)

    it 'refresh only with the latest search', ->
      controller.getNotifications(email)
      expect(spy.calls.argsFor(0)[0]).toEqual(email)
      controller.getNotifications('nottest@test.com')
      expect(spy.calls.argsFor(1)[0]).toEqual('nottest@test.com')
      jasmine.clock().tick(oneMinute)
      expect(spy.calls.argsFor(2)[0]).toEqual('nottest@test.com')
      expect(spy.calls.count()).toBe(3)

  describe '#unbind', ->
    it 'unbinds the notification button', ->
      setupController()

      spy = spyOn(controller.processor, 'getNotifications')
      $('[data-id=notification-button]').click()
      expect(spy.calls.count()).toBe(1)

      controller.unbind()
      $('[data-id=notification-button]').click()
      expect(spy.calls.count()).toBe(1)

    it 'unbinds the close-widget button', ->
      setupController()
      controller.unbind()

      $('[data-id=notification-close]').click()
      expect('#sandbox').toBeInDOM()
