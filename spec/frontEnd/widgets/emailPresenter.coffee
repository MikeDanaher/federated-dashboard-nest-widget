describe 'Notification.Widgets.EmailPresenter', ->
  alert = {
    id: '1',
    from: 'test@test.com',
    subject: '[alert] alert message',
  }

  notification = {
    id: '1',
    from: 'test@test.com',
    subject: '[notification] notification message',
  }

  newPresenter = (email) ->
    new Notification.Widgets.EmailPresenter(email)

  it 'wraps the email attributes', ->
    presenter = newPresenter(alert)
    expect(presenter.id).toEqual(alert.id)
    expect(presenter.from).toEqual(alert.from)

  describe 'generateBody', ->
    it 'generates proper body for an alert', ->
      presenter = newPresenter(alert)
      expect(presenter.body).toEqual('alert message')

    it 'generates proper body for an alert', ->
      presenter = newPresenter(notification)
      expect(presenter.body).toEqual('notification message')

    it 'escapes html tags', ->
      email = {
        id: '1',
        from: 'test@test.com',
        subject: '[notification] <script>alert("Escaped")</script>',
      }
      presenter = newPresenter(email)

      expect(presenter.body).toEqual("&lt;script&gt;alert(&quot;Escaped&quot;)&lt;/script&gt;")

  describe 'generateSymbol', ->
    it 'returns an exclamation symbol for a subject that has an alert', ->
      presenter = newPresenter(alert)
      expect(presenter.symbol).toEqual('<i class="red fa fa-exclamation-circle"></i>')

    it 'returns a notification symbol when subject has a notification', ->
      presenter = newPresenter(notification)
      expect(presenter.symbol).toEqual('<i class="fa fa-bell"></i>')
