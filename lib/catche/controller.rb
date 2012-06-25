require 'catche/controller/actions'
require 'catche/controller/pages'

module Catche
  module Controller

    extend ActiveSupport::Concern

    include Catche::Controller::Actions
    include Catche::Controller::Pages

    included do

      class_attribute :catche_model,
                      :catche_resource_name,
                      :catche_constructed_tags

    end

    module ClassMethods

      # Caches a controller action.
      #
      #   catche Project, :index, :resource_name => :project
      def catche(model, *args)
        options = args.extract_options!

        self.catche_model = model
        self.catche_resource_name = options[:resource_name] || self.catche_model.name.downcase.to_sym

        case options[:type]
          when :page then caches_page *args, options
          else            caches_action *args, options
        end
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