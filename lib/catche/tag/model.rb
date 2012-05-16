module Catche
  module Tag
    class Model

      class << self

        def for(model)
          name(model.name.tableize)
        end

        def name(name)
          name.to_s.pluralize.downcase
        end

      end

    end
  end
end