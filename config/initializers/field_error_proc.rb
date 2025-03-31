# frozen_string_literal: true

# config/initializers/field_error_proc.rb

ActionView::Base.field_error_proc = proc do |html_tag, _instance|
  "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe
end
