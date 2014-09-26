describe 'Notificatoin.Widgets.Controller', ->
  mockEmails = [{ id: '1' }, { id: '2' }]
  email = 'test@test.com'

  getResponse = (response) ->
    JSON.stringify(response)

  controller = undefined

  newController = (container) ->
    new Notification.Widgets.Controller({ container: container })

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
      $('.widget-form button').click()
      expect(spy).toHaveBeenCalledWith(controller.processor, email)
