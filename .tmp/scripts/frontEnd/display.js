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
