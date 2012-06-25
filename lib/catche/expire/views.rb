module Catche
  module Expire
    module Views

      class << self

        # Expires cache by deleting the associated keys
        #
        #   Catche::Expire::View.expire!('projects')
        def expire!(*keys)
          keys.each do |key|
            Catche.adapter.delete key
          end
        end

      end

    end
  end
end