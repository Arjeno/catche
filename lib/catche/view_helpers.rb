module Catche
  module ViewHelpers

    # Caches a fragment
    # See ActionView `cache` for more information
    #
    #   <% catche @project do %>
    #     <%= @project.title %>
    #   <% end %>
    #
    #   <% catche @project.tasks do %>
    #     <% @project.tasks.each do |task| %>
    #       <%= task.title %>
    #     <% end %>
    #   <% end %>
    def catche(model_or_resource, options=nil, &block)
      tags  = []
      name  = Catche::Tag.join 'fragment', model_or_resource.hash
      key   = ActiveSupport::Cache.expand_cache_key name, :views

      if model_or_resource.respond_to?(:catche_tag)
        if model_or_resource.respond_to?(:new)
          tags = Catche::Tag::Collect.collection(controller, model_or_resource.catche_class)[:set]
        else
          tags = Catche::Tag::Collect.resource(model_or_resource)[:set]
        end
      end

      Catche::Tag.tag_view! key, *tags if tags.any?

      cache name, options, &block
    end
    alias :catches_fragment :catche

  end
end