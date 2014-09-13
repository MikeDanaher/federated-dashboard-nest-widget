(function() {
  describe('Notification.Controller', function() {
    describe("setupWidgetIn", function() {
      return it("sets up a widget template in the given container", function() {
        setFixtures(sandbox());
        Notification.Controller.setupWidgetIn({
          container: '#sandbox'
        });
        expect($('#sandbox')).toContainElement('.widget');
        expect($('#sandbox')).toContainElement('.widget-header');
        expect($('#sandbox')).toContainElement('.widget-title');
        expect($('#sandbox')).toContainElement('.widget-close');
        expect($('#sandbox')).toContainElement('.widget-form');
        expect($('.widget-form')).toContainElement('input');
        return expect($('.widget-form')).toContainElement('button');
      });
    });
    describe("exitEditMode", function() {
      return it("hides the forms and the closing button", function() {
        setFixtures(sandbox());
        Notification.Controller.setupWidgetIn({
          container: '#sandbox'
        });
        Notification.Controller.exitEditMode();
        expect($('.widget-form').attr('style')).toEqual('display: none;');
        return expect($('.widget-close').attr('style')).toEqual('display: none;');
      });
    });
    return describe("enterEditMode", function() {
      return it("shows the forms and the closing button", function() {
        setFixtures(sandbox());
        Notification.Controller.setupWidgetIn({
          container: '#sandbox'
        });
        Notification.Controller.exitEditMode();
        expect($('.widget-form').attr('style')).toEqual('display: none;');
        expect($('.widget-close').attr('style')).toEqual('display: none;');
        Notification.Controller.enterEditMode();
        expect($('.widget-form').attr('style')).not.toEqual('display: none;');
        return expect($('.widget-close').attr('style')).not.toEqual('display: none;');
      });
    });
  });

}).call(this);
