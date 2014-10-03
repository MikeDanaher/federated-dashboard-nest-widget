namespace("Notification.Widgets")

class Notification.Widgets.Templates
  @renderForm: () ->
    _.template("""
                  <div class="widget" data-id="notification-widget-wrapper">
                    <div class="widget-header" data-name="sortable-handle">
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

  @renderEmails: (emails) ->
    _.template("""
    <% emails.forEach(function(email) { %>
      <div class="notification">
        <div class="notification-symbol">
          <%= email.symbol %>
        </div>
        <div class="notification-content">
          <div class="notification-author">
            <%= email.from %>
          </div>
          <div class="notification-body">
            <%= email.body %>
          </div>
        </div>
      </div>
    <% }) %>

    """, { emails: emails })
