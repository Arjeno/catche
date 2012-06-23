module Catche
  module Controller
    module Page

      extend ActiveSupport::Concern

      module ClassMethods

        # Caches an action by file
        # See ActionController `caches_page` for more information
        #
        #   catches_action Project, :index
        def catches_page(model, *args)
          catche model, *args, :type => :page
        end

        def cache_page(content, path, extension = nil, gzip = Zlib::BEST_COMPRESSION)
          if self.catche?
            Catche::Tag.tag_page! page_cache_path(path, extension), *catche_constructed_tags
          end

          super
        end

      end

      def cache_page(content = nil, options = nil, gzip = Zlib::BEST_COMPRESSION)
        self.class.catche_constructed_tags = catche_tags
        super
      end


    end
  end
end
