module Spotlight
  module UrlHelper
    def create_links(options = {})
      link_to nil, options[:value].first
    end
  end
end