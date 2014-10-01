describe 'Notificatin.Widgets.EmailProcessor', ->
  email1 = {
    id: '1',
    from: 'test@test.com',
    subject: '[alert] message1',
  }

  email2 = {
    id: '2',
    from: 'test@test.com',
    subject: '[notification] message2',
  }

  email3 = {
    id: '3',
    from: 'test@test.com',
    subject: '[alert] message3',
  }

  email4 = {
    id: '4',
    from: 'test@test.com message4',
    subject: '[alert]',
  }

  mockEmails       = -> [email1, email2]
  maxNotifications = 3
  mockDisplay      = { renderEmails: -> }
  newProcessor     = (display, numberOfEmails) ->
    new Notification.Widgets.EmailProcessor(display,numberOfEmails || maxNotifications)

  setupNewDisplay  = ->
    setFixtures sandbox()
    new Notification.Widgets.Display(container: '#sandbox')

  createEmailPresenters = (emails) ->
    emails.map((email) -> 
      new Notification.Widgets.EmailPresenter(email)
    )


  it 'getNotifications is getting emails from the api passing itself as a callback object', ->
    processor = newProcessor(mockDisplay)
    spy = spyOn(Notification.Widgets.API, 'getEmailsFrom')
    processor.getNotifications('test@test.com')

    expect(spy).toHaveBeenCalledWith(processor, 'test@test.com')

  it 'currentNotifications is empty on initialization', ->
    processor = newProcessor(mockDisplay)

    expect(processor.currentNotifications).toEqual([])

  describe '#processEmails', ->
    it 'gets all new emails from the API', ->
      processor = newProcessor(mockDisplay)
      spy = spyOn(Notification.Widgets.API, 'getEmail')
      processor.processEmails(mockEmails())

      expect(spy.calls.count()).toBe(2)

    it 'gets only the new emails from the API', ->
      processor = newProcessor(mockDisplay)
      processor.currentNotifications = mockEmails()
      spy = spyOn(Notification.Widgets.API, 'getEmail')
      processor.processEmails([email3])

      expect(spy).toHaveBeenCalledWith(email3.id, processor)
      expect(spy.calls.count()).toBe(1)


    it 'does NOT get emails from the api if there are no new emails', ->
      processor = newProcessor(mockDisplay)
      processor.notificationsHistory = mockEmails()
      spy = spyOn(Notification.Widgets.API, 'getEmail')
      processor.processEmails(mockEmails())

      expect(spy).not.toHaveBeenCalled()

  describe 'processEmail', ->
    it 'adds the email to the currentNotifications', ->
      processor = newProcessor(mockDisplay)
      processor.currentNotifications = mockEmails()
      processor.processEmail(email3)

      expect(processor.currentNotifications[0].id).toEqual('3')
      expect(processor.currentNotifications[1].id).toEqual('1')
      expect(processor.currentNotifications[2].id).toEqual('2')
      expect(processor.currentNotifications.length).toBe(3)

    it 'displays only the last emails', ->
      display = setupNewDisplay()
      processor = newProcessor(display, 2)
      setFixtures(sandbox())
      display.setup()
      email1Presenter = new Notification.Widgets.EmailPresenter(email1)
      email2Presenter = new Notification.Widgets.EmailPresenter(email2)
      processor.currentNotifications = [email2Presenter, email1Presenter]
      processor.processEmail(email3)

      expect('body').toContainText('message3')
      expect('body').toContainText('message2')
      expect('body').not.toContainText('message1')

    it 'adds all emails to notificationsHistory', ->
      display = setupNewDisplay()
      processor = newProcessor(display, 2)

      processor.processEmail(email1)
      expect(processor.notificationsHistory).toEqual([email1])

      processor.processEmail(email4)
      expect(processor.notificationsHistory).toEqual([email4, email1])

    it 'does not add emails that have no subject', ->
      email4.body = 'valid body'
      email4.subject = ''
      display = setupNewDisplay()
      processor = newProcessor(display, 2)
      processor.processEmail(email1)
      processor.processEmail(email4)

      expect(processor.currentNotifications.length).toEqual(1)
      expect(processor.currentNotifications[0].id).toEqual('1')

    it 'does not add emails that have an invalid subject', ->
      email3.subject = '[NOT alert]'
      display = setupNewDisplay()
      processor = newProcessor(display, 2)
      processor.processEmail(email1)
      processor.processEmail(email3)

      expect(processor.currentNotifications.length).toEqual(1)
      expect(processor.currentNotifications[0].id).toEqual('1')

    it 'wraps a valid email in a presenter', ->
      email3.subject = '[NOT alert]'
      display = setupNewDisplay()
      processor = newProcessor(display, 2)
      processor.processEmail(email1)
      validNotification = processor.currentNotifications[0]

      expect(validNotification.symbol).toEqual('<i class="red fa fa-exclamation-circle"></i>')
