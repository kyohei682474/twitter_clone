Rails.application.config.after_initialize do
  module TurboMethodPatch
    def link_to(name = nil, options = nil, html_options = nil, &block)
      html_options ||= {}

      # method指定があり、data-turbo-method が未指定の場合
      if html_options[:method] && (html_options[:data].nil? || !html_options[:data].key?(:turbo_method))
        html_options[:data] ||= {}
        html_options[:data][:turbo_method] = html_options[:method]
        html_options.delete(:method)
      end

      super(name, options, html_options, &block)
    end
  end

  ActionView::Helpers::UrlHelper.prepend(TurboMethodPatch)
end
