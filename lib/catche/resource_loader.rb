module Catche
  class ResourceLoader

    class << self

      # Fetches resources in the given context, for example a controller
      #
      #   Catche::Tag::ResourceLoader.fetch(controller, :task)
      def fetch(context, *names)
        names.collect do |name|
          if resource = context.instance_variable_get("@#{name}")
            resource
          elsif context.respond_to?(name)
            begin
              context.send(name)
            rescue
              nil
            end
          else
            nil
          end
        end.compact
      end

      def fetch_one(context, name)
        fetch(context, name).first
      end

      def exists?(context, name)
        fetch_one(context, name).present?
      end

    end

  end
end