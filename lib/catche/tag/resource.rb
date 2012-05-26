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
          object.instance_variable_get("@#{name}")
        end

        def associations(object, associations)
          associations.map { |association| resource(object, association) }.compact
        end

      end

    end
  end
end