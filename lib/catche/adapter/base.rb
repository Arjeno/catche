module Catche
  module Adapter
    class Base

      class << self

        def read(key, default_value=nil)
          adapter.read(key) || default_value
        end

        def write(key, value)
          adapter.write(key, value)
        end

        def delete(key)
          adapter.delete(key)
        end

        def adapter
          Rails.cache
        end

      end

    end
  end
end