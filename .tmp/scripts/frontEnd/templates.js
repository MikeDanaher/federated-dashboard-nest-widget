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
