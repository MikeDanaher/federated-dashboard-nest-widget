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

    Controller.settings = {};

    Controller.setupWidgetIn = function(settings) {
      new Notification.Widgets.Controller(settings).initialize();
      return this.settings = settings;
    };

    Controller.exitEditMode = function() {
      $('[data-id=notification-widget-wrapper] [data-id=notification-form]').hide(this.animationSpeed());
      return $('[data-id=notification-widget-wrapper] .widget-close').hide(this.animationSpeed());
    };

    Controller.enterEditMode = function() {
      $('[data-id=notification-widget-wrapper] [data-id=notification-form]').show(this.animationSpeed());
      return $('[data-id=notification-widget-wrapper] .widget-close').show(this.animationSpeed());
    };

    Controller.animationSpeed = function() {
      return this.settings.animationSpeed;
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Notification');

  Notification.Display = (function() {
    function Display() {}

    Display.generateLogo = function(config) {
      return "<i class=\"fa fa-bell " + config["class"] + "\" data-id=\"" + config.dataId + "\"></i>";
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace('Notification.Widgets');

  Notification.Widgets.API = (function() {
    function API() {}

    API.getEmailsFrom = function(processor, from) {
      return $.get("/emails?from=" + (from || '*@8thlight.com'), function(response) {
        return processor.processEmails(response);
      });
    };

    API.getEmail = function(id, processor) {
      return $.get("/emails/" + id, function(response) {
        return processor.processEmail(response);
      });
    };

    return API;

  })();

}).call(this);

(function() {
  namespace('Notification.Widgets');

  Notification.Widgets.Controller = (function() {
    function Controller(args) {
      this.container = args.container;
      this.refreshRate = args.refreshRate;
      this.defaultValue = args.defaultValue;
      this.isActive = false;
      this.display = new Notification.Widgets.Display(args);
      this.processor = new Notification.Widgets.EmailProcessor(this.display, args.maxNotifications);
    }

    Controller.prototype.initialize = function() {
      this.display.setup();
      this.bind();
      this.activate();
      return this.displayDefault();
    };

    Controller.prototype.bind = function() {
      $("" + this.container + " [data-id=notification-button]").on('click', (function(_this) {
        return function() {
          return _this.getNotifications(_this.display.getInput());
        };
      })(this));
      return $("" + this.container + " [data-id=notification-close]").on('click', (function(_this) {
        return function() {
          return _this.closeWidget();
        };
      })(this));
    };

    Controller.prototype.unbind = function() {
      $("" + this.container + " [data-id=notification-button]").unbind('click');
      return $("" + this.container + " [data-id=notification-close]").unbind('click');
    };

    Controller.prototype.activate = function() {
      return this.isActive = true;
    };

    Controller.prototype.deactivate = function() {
      return this.isActive = false;
    };

    Controller.prototype.displayDefault = function() {
      if (this.defaultValue) {
        return this.getNotifications(this.defaultValue);
      }
    };

    Controller.prototype.getNotifications = function(input) {
      this.processor.getNotifications(input);
      if (this.refreshRate) {
        return this.refreshNotifications(input);
      }
    };

    Controller.prototype.refreshNotifications = function(input) {
      this.clearCurrentTimeout();
      return this.timeout = setTimeout((function(_this) {
        return function() {
          if (_this.isActive) {
            return _this.getNotifications(input);
          }
        };
      })(this), this.refreshSeconds());
    };

    Controller.prototype.clearCurrentTimeout = function() {
      if (this.timeout) {
        return clearTimeout(this.timeout);
      }
    };

    Controller.prototype.closeWidget = function() {
      $(this.container).remove();
      this.deactivate();
      return this.unbind();
    };

    Controller.prototype.refreshSeconds = function() {
      return this.refreshRate * 1000;
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Notification.Widgets');

  Notification.Widgets.Display = (function() {
    function Display(args) {
      this.container = args.container;
    }

    Display.prototype.setup = function() {
      var templateHtml;
      templateHtml = Notification.Widgets.Templates.renderForm();
      return $(this.container).html(templateHtml);
    };

    Display.prototype.getInput = function() {
      return $("" + this.container + " [name=notification-search]").val();
    };

    Display.prototype.renderEmails = function(emails) {
      var emailsHtml;
      emailsHtml = Notification.Widgets.Templates.renderEmails(emails);
      return $("" + this.container + " [data-id=notification-output]").html(emailsHtml);
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace('Notification.Widgets');

  Notification.Widgets.EmailPresenter = (function() {
    function EmailPresenter(email) {
      this.id = email.id;
      this.from = email.from;
      this.subject = email.subject;
      this.symbol = this.generateSymbol(email.subject);
      this.body = this.generateBody(email.subject);
    }

    EmailPresenter.prototype.generateSymbol = function(subject) {
      if (this.contains(subject, '[alert]')) {
        return '<i class="red fa fa-exclamation-circle"></i>';
      } else {
        return '<i class="fa fa-bell"></i>';
      }
    };

    EmailPresenter.prototype.contains = function(checkStr, substr) {
      return checkStr.indexOf(substr) !== -1;
    };

    EmailPresenter.prototype.generateBody = function(subject) {
      var rawBody;
      rawBody = subject.split('] ')[1];
      return this.sanitizeBody(rawBody);
    };

    EmailPresenter.prototype.sanitizeBody = function(body) {
      _.each(this.charactersToEscape, (function(_this) {
        return function(escapedVersion, char) {
          var _results;
          _results = [];
          while (body.indexOf(char) !== -1) {
            _results.push(body = body.replace(char, escapedVersion));
          }
          return _results;
        };
      })(this));
      return body;
    };

    EmailPresenter.prototype.charactersToEscape = {
      '<': '&lt;',
      '>': '&gt;',
      '\"': '&quot;'
    };

    return EmailPresenter;

  })();

}).call(this);

(function() {
  namespace('Notification.Widgets');

  Notification.Widgets.EmailProcessor = (function() {
    function EmailProcessor(display, maxNotifications) {
      this.display = display;
      this.maxNotifications = maxNotifications;
      this.currentNotifications = [];
      this.notificationsHistory = [];
    }

    EmailProcessor.prototype.getNotifications = function(from) {
      return Notification.Widgets.API.getEmailsFrom(this, from);
    };

    EmailProcessor.prototype.processEmails = function(emails) {
      return _.each(emails.reverse(), (function(_this) {
        return function(email) {
          if (_this.isNewEmail(email)) {
            return _this.getNewEmail(email);
          }
        };
      })(this));
    };

    EmailProcessor.prototype.isNewEmail = function(email) {
      var isNewEmail;
      isNewEmail = true;
      _.each(this.notificationsHistory, function(existingEmail) {
        if (existingEmail.id === email.id) {
          return isNewEmail = false;
        }
      });
      return isNewEmail;
    };

    EmailProcessor.prototype.getNewEmail = function(email) {
      return Notification.Widgets.API.getEmail(email.id, this);
    };

    EmailProcessor.prototype.processEmail = function(email) {
      this.addToHistory(email);
      if (this.hasValidSubject(email)) {
        return this.displayEmail(email);
      }
    };

    EmailProcessor.prototype.hasValidSubject = function(email) {
      return email.subject && this.containsNotificationType(email.subject);
    };

    EmailProcessor.prototype.containsNotificationType = function(subject) {
      return this.contains(subject, '[alert] ') || this.contains(subject, '[notification] ');
    };

    EmailProcessor.prototype.contains = function(checkStr, substr) {
      return checkStr.indexOf(substr) !== -1;
    };

    EmailProcessor.prototype.displayEmail = function(email) {
      this.addToCurrentNotifications(email);
      return this.display.renderEmails(this.recentEmails());
    };

    EmailProcessor.prototype.addToHistory = function(email) {
      return this.addToBegining(this.notificationsHistory, email);
    };

    EmailProcessor.prototype.addToCurrentNotifications = function(email) {
      return this.addToBegining(this.currentNotifications, this.createPresenter(email));
    };

    EmailProcessor.prototype.createPresenter = function(email) {
      return new Notification.Widgets.EmailPresenter(email);
    };

    EmailProcessor.prototype.addToBegining = function(container, element) {
      return container.unshift(element);
    };

    EmailProcessor.prototype.recentEmails = function() {
      return this.currentNotifications.slice(0, this.maxNotifications);
    };

    return EmailProcessor;

  })();

}).call(this);

(function() {
  namespace("Notification.Widgets");

  Notification.Widgets.Templates = (function() {
    function Templates() {}

    Templates.renderForm = function() {
      return _.template("<div class=\"widget\" data-id=\"notification-widget-wrapper\">\n  <div class=\"widget-header\">\n    <h2 class=\"widget-title\">Notifications</h2>\n    <span class='widget-close' data-id='notification-close'>×</span>\n    <div class=\"widget-form\" data-id=\"notification-form\">\n      <input name=\"notification-search\" type=\"text\" autofocus=\"true\">\n      <button data-id=\"notification-button\">Load Notifications</button><br>\n    </div>\n  </div>\n  <div class=\"widget-body\" data-id=\"notification-output\"></div>\n</div>", {});
    };

    Templates.renderEmails = function(emails) {
      return _.template("<% emails.forEach(function(email) { %>\n  <div class=\"notification\">\n    <div class=\"notification-symbol\">\n      <%= email.symbol %>\n    </div>\n    <div class=\"notification-content\">\n      <div class=\"notification-author\">\n        <%= email.from %>\n      </div>\n      <div class=\"notification-body\">\n        <%= email.body %>\n      </div>\n    </div>\n  </div>\n<% }) %>\n", {
        emails: emails
      });
    };

    return Templates;

  })();

}).call(this);
