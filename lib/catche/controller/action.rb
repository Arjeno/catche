module Catche
  module Controller
    module Action

      extend ActiveSupport::Concern

      module ClassMethods

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
