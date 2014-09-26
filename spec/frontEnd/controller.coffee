describe 'Notification.Controller', ->
  describe "setupWidgetIn", ->
    it "sets up a widget template in the given container", ->
      setFixtures sandbox()
      Notification.Controller.setupWidgetIn({container: '#sandbox'})

      expect($('#sandbox')).toContainElement('.widget')

  describe "exitEditMode", ->
    it "hides the forms and the closing button", ->
      setFixtures sandbox()
      Notification.Controller.setupWidgetIn({container: '#sandbox'})
      Notification.Controller.exitEditMode()

      expect($('.widget-form').attr('style')).toEqual('display: none;')
      expect($('.widget-close').attr('style')).toEqual('display: none;')

  describe "enterEditMode", ->
    it "shows the forms and the closing button", ->
      setFixtures sandbox()
      Notification.Controller.setupWidgetIn({container: '#sandbox'})
      Notification.Controller.exitEditMode()

      expect($('.widget-form').attr('style')).toEqual('display: none;')
      expect($('.widget-close').attr('style')).toEqual('display: none;')

      Notification.Controller.enterEditMode()

      expect($('.widget-form').attr('style')).not.toEqual('display: none;')
      expect($('.widget-close').attr('style')).not.toEqual('display: none;')
