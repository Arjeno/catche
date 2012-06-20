module Catche
  module Controller
    module Base

      extend ActiveSupport::Concern

      module ClassMethods

        # Caches a controller action by tagging it.
        # Supports any option parameters caches_action supports.
        #
        #   catche Project, :index
        #   catche Task, :through => :project
        def catche(model, *args)
          options = args.extract_options!
          object  = Catche::Tag::Object.register!(model, self, options)
          tag     = Proc.new { |controller| object }

          # Use Rails caches_action to pass along the tag
          caches_action(*args, { :tag => tag }.merge(options))
        end

      end

      def _save_fragment(name, options={})
        key     = fragment_cache_key(name)
        object  = options[:tag]
        tags    = []

        if object.present?
          if object.respond_to?(:call)
            object = self.instance_exec(self, &object)

            if object.respond_to?(:tags)
              tags = object.tags(self)
            else
              tags = Array.new(object)
            end
          else
            tags = Array.new(object)
          end

          Catche::Tag.tag! key, *tags

          # Store for future reference
          @catche_cache_object = object
        end

        super
      end

    end
  end
end

ActionController::Base.send :include, Catche::Controller::Base