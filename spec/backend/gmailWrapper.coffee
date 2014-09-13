GoogleOauthWrapper = require('../../scripts/backend/googleOauthWrapper')
expect             = require('chai').expect
sinon              = require('sinon')

describe 'GoogleOauthWrapper', ->
  mockCode = 'mock_code'
  mockToken = 'mock_token'

  mockCodeRequest = {
    query: {
      code: mockCode
    }
  }

  scopes = ['first', 'second']

  newWrapper = (oauth, scopes) ->
    new GoogleOauthWrapper(oauth, scopes)

  it 'generateAuthUrl is getting the oauth url with the proper params', ->
    spy = sinon.spy()
    oauthClient = {
      generateAuthUrl: spy
    }
    wrapper = newWrapper(oauthClient, scopes)
    wrapper.generateAuthUrl()

    expect(spy.callCount).to.equal(1)
    expect(spy.getCall(0).args[0]).to.eql({
      access_type: 'offline',
      scope: scopes
    })

  it 'getUserToken is getting the user user token with the received code', ->
    spy = sinon.spy()
    oauthClient = {
      getToken: spy
    }
    wrapper = newWrapper(oauthClient, scopes)
    wrapper.getUserToken(mockCodeRequest)

    expect(spy.callCount).to.equal(1)
    expect(spy.getCall(0).args[0]).to.eql(mockCode)

  it 'getUserToken is adding the token to the client credentials', ->
    spy = sinon.spy()
    oauthClient = {
      getToken: (code, callback) ->
        callback(null, mockToken)
      setCredentials: spy
    }
    wrapper = newWrapper(oauthClient, scopes)
    wrapper.getUserToken(mockCodeRequest)

    expect(spy.callCount).to.equal(1)
    expect(spy.getCall(0).args[0]).to.eql(mockToken)
