module Catche
  module Tag
    class Controller

      class << self

        @@controller_tags = []

        # Returns an existing (duplicate) or new tag object for the given arguments.
        #
        #   Catche::Tag::Controller.for(Project, ProjectsController)
        def for(model, controller, options={})
          tag_object = find_or_initialize(model, controller.class, options)

          objects << tag_object
          objects.uniq!

          tag_object
        end

        # Finds a previously declared (same) tag object or returns a new one.
        def find_or_initialize(model, controller, options={})
          new_object = self.new(model, controller, options)

          objects.each do |tag_object|
            return tag_object if tag_object.same?(new_object)
          end

          new_object
        end

        def find_by_model(model)
          objects.select { |tag_object| tag_object.model == model }
        end

        def find_by_association(association)
          objects.select { |tag_object| tag_object.associations.include?(association) }
        end

        def clear
          @@controller_tags = []
        end

        def objects
          @@controller_tags
        end

      end

      attr_reader :model, :controller, :options
      attr_accessor :associations

      def initialize(model, controller, options={})
        @model = model
        @controller = controller

        association = options[:through]

        @options = {
          :resource_name    => Catche::Tag::Resource.singularize(@model),
          :collection_name  => Catche::Tag::Resource.pluralize(@model),
          :associations     => [association].flatten.compact,
          :bubble           => false
        }.merge(options)

        @associations = @options[:associations]
      end

      # Returns the tags for the given controller.
      # If `bubble` is set to true it will pass along the separate tag for each association.
      # This means the collection or resource is expired as soon as the association changes.
      #
      #   object = Catche::Tag::Controller.new(Task, TasksController, :through => [:user, :project])
      #   object.tags(controller) => ['users_1_projects_1_tasks_1']
      def tags(controller)
        tags = []

        tags += association_tags(controller) if bubble?
        tags += expiration_tags(controller)

        tags
      end

      # The tags that should expire as soon as the resource or collection changes.
      def expiration_tags(controller)
        [Catche::Tag.join(association_tags(controller), identifier_tags(controller))]
      end

      # Identifying tag for the current resource or collection.
      #
      #   object = Catche::Tag::Controller.new(Task, TasksController)
      #   object.identifier_tags(controller) => ['tasks', 1]
      def identifier_tags(controller)
        Catche::Tag.join options[:collection_name], Catche::Tag::Resource.resource(controller, options[:resource_name]).try(:id)
      end

      # Maps the given resources names to tags by fetching the resources from the given object.
      def resource_tags(*resources)
        resources.map { |resource| Catche::Tag.join(Catche::Tag::Resource.pluralize(resource.class), resource.id) }
      end

      # Maps association tags.
      #
      #   object = Catche::Tag::Controller.new(Task, TasksController, :through => [:user, :project])
      #   object.association_tags(@controller) => ['users_1', 'projects_1']
      def association_tags(object)
        resource_tags(*Catche::Tag::Resource.associations(object, associations))
      end

      def bubble?
        options[:bubble]
      end

      def same?(object)
        self.model      == object.model &&
        self.controller == object.controller &&
        self.options    == object.options
      end

    end
  end
end