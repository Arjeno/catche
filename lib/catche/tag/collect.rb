module Catche
  module Tag
    class Collect

      class << self

        # Collects resource tags for a given resource
        #
        #   Catche::Tag::Tagger.resource_tags(@task)
        #   => { :set => ["tasks_1"], :expire => ["tasks_1"] }
        def resource(resource)
          set_tags    = []
          expire_tags = []

          set_tags    << resource.catche_tag
          expire_tags << resource.catche_tag

          {
            :set    => set_tags.uniq,
            :expire => expire_tags.uniq
          }
        end

        # Collects collection tags for a given context, for example a controller
        #
        #   Catche::Tag::Tagger.collection_tags(controller, Task)
        #   => { :set => ["projects_1_tasks"], :expire => ["tasks", "projects_1_tasks"] }
        def collection(context, resource_class, include_base=true)
          associations      = Catche::ResourceLoader.fetch(context, *resource_class.catche_associations)
          association_tags  = associations.map { |a| a.catche_tag }

          set_tags    = []
          expire_tags = []

          if association_tags.any?
            set_tags  << Tag.join(*association_tags, resource_class.catche_tag)
          else
            # Without any associations, add just the collection tag
            set_tags  << resource_class.catche_tag
          end

          expire_tags << resource_class.catche_tag if include_base
          expire_tags += set_tags

          {
            :set    => set_tags.uniq,
            :expire => expire_tags.uniq
          }
        end

      end

    end
  end
end