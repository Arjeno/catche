module Catche
  module Expire
    module Pages

      class << self

        # Expires cache by deleting the associated files
        # Uses the same flow as defined in `expire_page` in ActionController
        #
        #   Catche::Expire::Page.expire!('/public/projects.html')
        def expire!(*paths)
          paths.each do |path|
            File.delete(path) if File.exist?(path)
            File.delete(path + '.gz') if File.exist?(path + '.gz')
          end
        end

      end

    end
  end
end