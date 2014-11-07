describe 'Notification.Widgets.Display', ->
  display      = undefined
  setupDisplay = ->
    setFixtures sandbox()
    display = new Notification.Widgets.Display({container: '#sandbox'})
    display.setup()

  email1 = {
    id: '1',
    from: 'test1@test.com',
    symbol: 'test symbol1',
    body: 'test body2'
  }

  email2 = {
    id: '2',
    from: 'test2@test.com',
    symbol: 'test symbol2',
    body: 'test body2'
  }

  it 'setup displays the form in the given container', ->
    setupDisplay()
    expect($('#sandbox')).toContainElement('.widget')
    expect($('#sandbox')).toContainElement('.widget-header')
    expect($('#sandbox')).toContainElement('.widget-title')
    expect($('#sandbox')).toContainElement('.widget-close')
    expect($('#sandbox')).toContainElement('.widget-form')
    expect($('.widget-form')).toContainElement('input')
    expect($('.widget-form')).toContainElement('button')

  it 'getInput is returning text in the input field', ->
    setupDisplay()
    $('.widget-form input').val('test@test.com')

    expect(display.getInput()).toEqual('test@test.com')

  it 'renderEmails is displaying the emails given', ->
    setupDisplay()
    display.renderEmails([email1, email2])
    container = $(display.container)
    expect(container).toContainText(email1.from)
    expect(container).toContainText(email1.body)
    expect(container).toContainText(email1.symbol)

    expect(container).toContainText(email2.from)
    expect(container).toContainText(email2.body)
    expect(container).toContainText(email2.symbol)
