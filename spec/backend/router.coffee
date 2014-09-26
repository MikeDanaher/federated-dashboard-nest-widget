Router = require('../../scripts/backend/router')
expect = require('chai').expect
sinon  = require('sinon')

describe 'Router', ->
  describe 'getPermission', ->
    it 'redirects to the authentication url', ->
      spy = sinon.spy()
      mockResponse = {
        redirect: spy
      }

      Router.getPermission('request', mockResponse)

      expect(spy.callCount).to.eql(1)
      expect(spy.getCall(0).args[0]).to.contain('https://accounts.google.com')
