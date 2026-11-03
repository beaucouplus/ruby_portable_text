require "uri"

module PortableText
  module Html
    # Helpers for classifying URLs in portable-text links so the renderer can
    # decide when to add target="_blank" rel="noopener noreferrer".
    module Url
      INTERNAL_HOSTS = %w[huntwise.com www.huntwise.com].freeze

      module_function

      # An href is "external" only when it parses as an absolute URL pointing at
      # a host that is NOT huntwise.com (or a subdomain thereof). Relative paths
      # (`/foo`), anchor links (`#bar`), `mailto:`, and `tel:` stay in-page.
      def external?(href)
        return false if href.nil? || href.empty?
        return false if href.start_with?("/", "#", "?")
        return false if href.match?(/\A(mailto|tel|sms|javascript):/i)

        uri = begin
          URI.parse(href)
        rescue URI::InvalidURIError
          return false
        end

        return false if uri.host.nil? || uri.host.empty?
        host = uri.host.downcase
        return false if INTERNAL_HOSTS.include?(host)
        return false if host.end_with?(".huntwise.com")

        true
      end
    end
  end
end
