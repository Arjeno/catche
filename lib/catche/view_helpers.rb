module Catche
  module ViewHelpers

    # Caches a fragment
    # See ActionView `cache` for more information
    #
    #   <% catche @project do %>
    #     <%= @project.title %>
    #   <% end %>
    #
    #   <% catche @projects, :model => Project do %>
    #     <% @projects.each do |project| %>
    #       <%= project.title %>
    #     <% end %>
    #   <% end %>
    def catche(model_or_resource, options={}, &block)
      tags    = []
      name    = Catche::Tag.join 'fragment', model_or_resource.hash
      key     = ActiveSupport::Cache.expand_cache_key name, :views
      object  = options[:model] || model_or_resource

      if object.respond_to?(:catche_tag)
        if object.respond_to?(:new)
          tags = Catche::Tag::Collect.collection(controller, object)[:set]
        else
          tags = Catche::Tag::Collect.resource(object)[:set]
        end
      end

      Catche::Tag.tag_view! key, *tags if tags.any?

      cache name, options, &block
    end
    alias :catches_fragment :catche

  end
end