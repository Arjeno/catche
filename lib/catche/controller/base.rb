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
          tag     = Proc.new { |c| Catche::Tag::Controller.for(model, c, options) }

          # Use Rails caches_action to pass along the tag
          caches_action *args, { :tag => tag }.merge(options)
        end

      end

      def _save_fragment(name, options={})
        key = fragment_cache_key(name)
        tag = options[:tag]

        if tag.present?
          tag = self.instance_exec(self, &tag) if tag.respond_to?(:call)
          # TODO: Tag the stored key
        end

        super
      end

    end
  end
end

ActionController::Base.send :include, Catche::Controller::Base