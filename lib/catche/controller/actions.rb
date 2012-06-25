module Catche
  module Controller
    module Actions

      extend ActiveSupport::Concern

      module ClassMethods

        # Caches an action in Rails.cache
        # See ActionController `caches_action` for more information
        #
        #   catches_action Project, :index
        def catches_action(model, *args)
          catche model, *args, :type => :action
        end

      end

      def _save_fragment(name, options={})
        if self.class.catche?
          key = fragment_cache_key(name)
          Catche::Tag.tag_view! key, *catche_tags
        end

        super
      end

    end
  end
end
