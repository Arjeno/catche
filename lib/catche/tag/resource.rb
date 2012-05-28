module Catche
  module Tag
    class Resource

      class << self

        def pluralize(object)
          object.name.to_s.pluralize.downcase
        end

        def singularize(object)
          object.name.to_s.singularize.downcase
        end

        def resource(object, name)
          if resource = object.instance_variable_get("@#{name}")
            return resource
          elsif object.respond_to?(name)
            begin
              return object.send(name)
            rescue; end
          end

          nil
        end

        def associations(object, associations)
          associations.map { |association| resource(object, association) }.compact
        end

      end

    end
  end
end