# frozen_string_literal: true

module TurboMethodPatch
  def link_to(name = nil, options = nil, html_options = nil, &block)
    html_options ||= {}

    if html_options[:method] && (html_options[:data].nil? || !html_options[:data].key?(:turbo_method))
      html_options[:data] ||= {}
      html_options[:data][:turbo_method] = html_options[:method]
      html_options.delete(:method)
    end

    super(name, options, html_options, &block)
  end
end

Rails.application.config.after_initialize do
  ActionView::Helpers::UrlHelper.prepend(TurboMethodPatch)
end
