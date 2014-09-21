GoogleEmailWrapper = require('../../scripts/backend/googleEmailWrapper')
expect             = require('chai').expect
sinon              = require('sinon')
base64             = require('base64')

describe 'GoogleEmailWrapper', ->
  oauthClient = {}
  emailBody = 'email body'
  encodedBody = base64.encode(emailBody)

  subjectHeader = { name: 'Subject', value: 'test' }
  fromHeader    = { name: 'From', value: 'test@test.com' }
  otherHeader   = { name: 'Other-header', value: 'other-header' }

  mockPayload = {
    body:    { data: encodedBody },
    headers: [subjectHeader, fromHeader, otherHeader]
  }

  mockEmail   = {
    id: 'someId',
    payload: mockPayload
  }

  mockMessages = [ mockEmail ]
  mockListResponse  = { messages: mockMessages }

  successfulResource = {
    list: (args, callback)->
      callback(null, mockListResponse)
    get: (args, callback) ->
      callback(null, mockEmail)
  }

  errResource = {
    list: (args, callback)->
      callback('error')
    get: (args, callback) ->
      callback('error')
  }

  wrapperArgs = (resource) ->
    {
      maxResults: 3,
      auth:       oauthClient,
      resource:   resource || successfulResource
    }

  newWrapper = (resource) ->
    new GoogleEmailWrapper(wrapperArgs(resource))

  it 'sets max result to 5 when no value is provided', ->
    wrapper = new GoogleEmailWrapper({})
    expect(wrapper.maxResults).to.eql(5)

  describe 'getEmailsFrom', ->
    it 'calls resource list method with proper arguments', ->
      spy = sinon.spy(successfulResource, 'list')
      mockFunction =  ->
      newWrapper().getEmailsFrom('alex@alex.com', mockFunction)

      expect(spy.callCount).to.eql(1)
      expect(spy.getCall(0).args[0]).to.eql({
        userId:     'me',
        maxResults: 3,
        q: 'from:alex@alex.com',
        auth: oauthClient
      })

    it 'calls the callback with the response received from the resource', ->
      spy = sinon.spy()
      newWrapper().getEmailsFrom('alex@alex.com', spy)

      expect(spy.callCount).to.eql(1)
      expect(spy.getCall(0).args[0]).to.eql(mockMessages)

    it 'calls the callback the error when there is an error', ->
      spy = sinon.spy()
      newWrapper(errResource).getEmailsFrom('alex@alex.com', spy)

      expect(spy.callCount).to.eql(1)
      expect(spy.getCall(0).args[0]).to.eql('error')

  describe 'getFormatedEmailById', ->
    it 'it calls the callback with formated email received from the resource', ->
      spy = sinon.spy()
      newWrapper().getFormatedEmailById('someId', spy)

      expect(spy.callCount).to.eql(1)
      expect(spy.getCall(0).args[0]).to.eql({
        from:    fromHeader.value,
        subject: subjectHeader.value,
        body:    emailBody
      })

    it 'calls the callback the error when there is an error', ->
      spy = sinon.spy()
      newWrapper(errResource).getFormatedEmailById('someId', spy)

      expect(spy.callCount).to.eql(1)
      expect(spy.getCall(0).args[0]).to.eql('error')

    it 'calls resource get method with proper arguments', ->
      spy = sinon.spy(successfulResource, 'get')
      mockFunction =  ->
      newWrapper().getFormatedEmailById('someId', mockFunction)

      expect(spy.callCount).to.eql(1)
      expect(spy.getCall(0).args[0]).to.eql({
        userId: 'me',
        id:     'someId',
        auth:    oauthClient
      })
