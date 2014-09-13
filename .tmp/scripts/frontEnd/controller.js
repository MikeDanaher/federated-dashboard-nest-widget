(function() {
  namespace('Notification');

  Notification.Controller = (function() {
    function Controller() {}

    Controller.setupWidgetIn = function(settings) {
      var templateHtml;
      templateHtml = Notification.Templates.renderForm();
      return $(settings.container).html(templateHtml);
    };

    Controller.exitEditMode = function() {
      $('[data-id=notification-form]').hide();
      return $('.widget-close').hide();
    };

    Controller.enterEditMode = function() {
      $('[data-id=notification-form]').show();
      return $('.widget-close').show();
    };

    return Controller;

  })();

}).call(this);
