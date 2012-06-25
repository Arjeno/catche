module Catche
  module Tag
    class Collect

      class << self

        # Collects resource tags for a given resource
        #
        #   Catche::Tag::Collect.resource_tags(@task)
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

        # Collects collection tags for a given context, for example the resource or a controller
        #
        #   Catche::Tag::Collect.collection(@task)
        #   => { :set => ["projects_1_tasks"], :expire => ["tasks", "projects_1_tasks"] }
        def collection(context, resource_class=nil, include_base=true)
          resource_class  ||= context.class
          associations      = Catche::ResourceLoader.fetch(context, *resource_class.catche_associations)
          association_tags  = associations.map { |a| a.catche_tag }

          set_tags    = []
          expire_tags = []

          association_tags.each do |tag|
            set_tags  << Tag.join(tag, resource_class.catche_tag)
          end

          set_tags    << resource_class.catche_tag if association_tags.blank?

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