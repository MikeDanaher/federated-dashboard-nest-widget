describe 'Notification.Controller', ->
  describe "setupWidgetIn", ->
    it "sets up a widget template in the given container", ->
      setFixtures sandbox()
      Notification.Controller.setupWidgetIn({container: '#sandbox'})

      expect($('#sandbox')).toContainElement('.widget')
