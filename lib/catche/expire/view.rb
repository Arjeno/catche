module Catche
  module Expire
    module View

      class << self

        def expire!(*keys)
          keys.each do |key|
            Catche.adapter.delete key
          end
        end

      end

    end
  end
end