module Catche
  module Controller
    module Page

      extend ActiveSupport::Concern

      module ClassMethods

        def catches_page(model, *args)
          options = args.extract_options!

          self.catche_model = model
          self.catche_resource_name = options[:resource_name] || self.catche_model.name.downcase.to_sym

          caches_page *args, options
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
