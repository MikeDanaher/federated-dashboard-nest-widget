describe 'Notification.Widgets.EmailPresenter', ->
  email = {
    id: '1',
    from: 'test@test.com',
    subject: 'test subject1',
    body: 'test body'
  }

  newPresenter = (email) ->
    new Notification.Widgets.EmailPresenter(email)

  it 'wraps the email attributes', ->
    presenter = newPresenter(email)

    expect(presenter.id).toEqual(email.id)
    expect(presenter.from).toEqual(email.from)
    expect(presenter.body).toEqual(email.body)

  describe 'generateSymbol', ->
    it 'returns an exclamation symbol for a subject that has an alert', ->
      email.subject = '[alert]'
      presenter = newPresenter(email)

      expect(presenter.symbol).toEqual('<i class="red fa fa-exclamation-circle"></i>')

    it 'returns a notification symbol when subject has a notification', ->
      email.subject = '[notification]'
      presenter = newPresenter(email)

      expect(presenter.symbol).toEqual('<i class="fa fa-bell"></i>')
