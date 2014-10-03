namespace("Notification.Widgets")

class Notification.Widgets.Templates
  @renderForm: () ->
    _.template("""
                  <div class='widget' data-name='widget-wrapper'>
                    <div class='widget-header' data-name='sortable-handle'>
                      <h2 class="widget-title">Notifications</h2>
                      <span class='widget-close' data-name='widget-close'>×</span>
                      <form class='widget-form' data-name='widget-form'>
                        <input name='widget-input' type='text' autofocus='true'>
                        <button data-name="form-button">Load Notifications</button><br>
                      </form>
                    </div>
                    <div class="widget-body" data-name="widget-output"></div>
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
