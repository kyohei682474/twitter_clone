Rails.application.config.action_view.field_error_proc = proc do |html_tag, _instance|
  html_tag.html_safe
end
