(function(underscore) {
  'use strict';

  window.namespace = function(string, obj) {
    var current = window,
        names = string.split('.'),
        name;

    while((name = names.shift())) {
      current[name] = current[name] || {};
      current = current[name];
    }

    underscore.extend(current, obj);

  };

}(window._));

(function() {
  namespace('Notification');

  Notification.Controller = (function() {
    function Controller() {}

    Controller.setupWidgetIn = function(settings) {
      var templateHtml;
      templateHtml = Notification.Templates.renderForm();
      $(settings.container).html(templateHtml);
      return this.bind();
    };

    Controller.bind = function() {
      return $('[data-id=notification-button]').click((function(_this) {
        return function(event) {
          console.log('clicked');
          event.preventDefault();
          return _this.getEmails();
        };
      })(this));
    };

    Controller.getEmails = function() {
      return $.post('/get_emails', {}, function(response) {
        return console.log(response);
      });
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

(function() {
  namespace('Notification');

  Notification.Display = (function() {
    function Display() {}

    Display.generateLogo = function(config) {
      return "<i class=\"fa fa-thumbs-o-up " + config["class"] + "\" data-id=\"" + config.dataId + "\"></i>";
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace("Notification");

  Notification.Templates = (function() {
    function Templates() {}

    Templates.renderForm = function() {
      return _.template("<div class=\"widget\" data-id=\"notification-widget-wrapper\">\n  <div class=\"widget-header\">\n    <h2 class=\"widget-title\">Notifications</h2>\n    <span class='widget-close' data-id='notification-close'>×</span>\n    <div class=\"widget-form\" data-id=\"notification-form\">\n      <input name=\"notification-search\" type=\"text\" autofocus=\"true\">\n      <button data-id=\"notification-button\">Load Notifications</button><br>\n    </div>\n  </div>\n  <div class=\"widget-body\" data-id=\"notification-output\"></div>\n</div>", {});
    };

    return Templates;

  })();

}).call(this);
