module Catche
  module Tag
    class Controller

      class << self

        @@controller_tags = []

        def for(model, controller, options={})
          tag_object = find_or_initialize(model, controller.class, options)

          @@controller_tags << tag_object
          @@controller_tags.uniq!

          # Lastly return the tags
          tag_object.tags(controller.params)
        end

        def find_or_initialize(model, controller, options={})
          @@controller_tags.each do |tag_object|
            return tag_object if tag_object.same?(model, controller, options)
          end

          nil
        end

        def find_by_model(model)

        end

        def find_by_association(association)

        end

      end

      attr_reader :model, :controller, :options
      attr_accessor :associations

      def initialize(model, controller, options={})
        @model = model
        @controller = controller

        association = options.delete :through

        @options = {
          :resource_param => :id,
          :associations   => [association].flatten.compact,
          :bubble         => false
        }.merge(options)

        @associations = @options[:associations]
      end

      # Returns the tags for the given controller.
      # If `bubble` is set to true it will pass along the separate tag for each association.
      # This means the collection or resource is expired as soon as the association changes.
      #
      #   object = Catche::Tag::Controller.new(Task, TasksController, :through => [:user, :project])
      #   object.tags(controller) => ['users_1_projects_1_tasks_1']
      def tags(params={})
        tags = []

        tags += association_tags(params) if bubble?
        tags += expire_tags(params)

        tags
      end

      def expire_tags(params={})
        [Catche::Tag.join(association_tags(params), identifier_tags(params))]
      end

      # Identifying tag for the current resource or collection.
      #
      #   object = Catche::Tag::Controller.new(Task, TasksController)
      #   object.identifier_tags(:id => 1) => ['tasks', 1]
      #   object.identifier_tags => ['tasks']
      def identifier_tags(params={})
        [Catche::Tag::Model.for(model), params[options[:resource_param]]].compact
      end

      # Maps association tags.
      #
      #   object = Catche::Tag::Controller.new(Task, TasksController, :through => [:user, :project])
      #   object.association_tags(:user_id => 1, :project_id => 1) => ['users_1', 'projects_1']
      def association_tags(params={})
        associations.map do |association|
          association_tag = Catche::Tag::Model.name(association)
          (id = params["#{association}_id".to_sym]).present? ? Catche::Tag.join(association_tag, id) : nil
        end.compact
      end

      def bubble?
        options[:bubble]
      end

      def same?(model, controller, options={})
        self.model == model && self.controller == controller && self.options == options
      end

    end
  end
end