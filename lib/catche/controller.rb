module Catche
  module Controller

    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Action
      autoload :Page
    end

    include Action, Page

    included do

      class_attribute :catche_model,
                      :catche_resource_name,
                      :catche_constructed_tags

    end

    module ClassMethods

      # Caches a controller action by tagging it.
      # Supports any option parameters caches_action supports.
      #
      #   catche Project, :index, :resource_name => :project
      def catche(model, *args)
        options = args.extract_options!

        self.catche_model = model
        self.catche_resource_name = options[:resource_name] || self.catche_model.name.downcase.to_sym

        # Use Rails caches_action to pass along the tag
        caches_action(*args, options.merge({ :catche => true }))
      end

      def catche?
        self.catche_model.present?
      end

    end

    def catche_tags
      return @catche_tags if ! @catche_tags.nil?

      if resource = Catche::ResourceLoader.fetch_one(self, self.class.catche_resource_name)
        tags = Catche::Tag::Collect.resource(resource)
        @catche_tags = tags[:set]
      else
        tags = Catche::Tag::Collect.collection(self, self.class.catche_model)
        @catche_tags = tags[:set]
      end
    end

  end
end

ActionController::Base.send :include, Catche::Controller