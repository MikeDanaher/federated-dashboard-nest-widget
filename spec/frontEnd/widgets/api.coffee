describe 'Notification.Widgets.API', ->
  mockEmails = [{ id: '1' }, { id: '2' }]
  mockEmail  = {
    id: '1',
    from: 'test@test.com',
    subject: 'subject',
    body: 'email body'
  }

  getResponse = (response) ->
    JSON.stringify(response)

  mockProcessor = {
    processEmails: ->
    processEmail:  ->
  }

  describe '#getEmailsFrom', ->
    it 'gets the emails from the given user', ->
      spyOn($, 'get')
      Notification.Widgets.API.getEmailsFrom(mockProcessor, 'test')

      expect($.get.calls.mostRecent().args[0]).toEqual('/emails?from=test')

    it 'gets all the emails from an @8thlight.com account if from argument is not given', ->
      spyOn($, 'get')
      Notification.Widgets.API.getEmailsFrom(mockProcessor)

      expect($.get.calls.mostRecent().args[0]).toEqual('/emails?from=*@8thlight.com')


    it 'passes the server response to processor.processEmails', ->
      server = sinon.fakeServer.create()
      mockResponse = getResponse(mockEmails)
      server.respondWith('/emails?from=*@8thlight.com', mockResponse)
      spy = spyOn(mockProcessor, 'processEmails')
      Notification.Widgets.API.getEmailsFrom(mockProcessor)
      server.respond()

      expect(spy).toHaveBeenCalledWith(mockResponse)
      server.restore()

  describe '#getEmail', ->
    it 'passes the server response to processor.processEmail', ->
      server = sinon.fakeServer.create()
      mockResponse = getResponse(mockEmail)
      server.respondWith(/.+/, mockResponse)
      spy = spyOn(mockProcessor, 'processEmail')
      Notification.Widgets.API.getEmail('1', mockProcessor)
      server.respond()
      expect(spy).toHaveBeenCalledWith(mockResponse)
