namespace("Notification")

class Notification.Templates
  @renderForm: () ->
    _.template("""
                  <div class="widget" data-id="notification-widget-wrapper">
                    <div class="widget-header">
                      <h2 class="widget-title">Notifications</h2>
                      <span class='widget-close' data-id='notification-close'>×</span>
                      <div class="widget-form" data-id="notification-form">
                        <input name="notification-search" type="text" autofocus="true">
                        <button data-id="notification-button">Load Notifications</button><br>
                      </div>
                    </div>
                    <div class="widget-body" data-id="notification-output"></div>
                  </div>
                """, {})
