module Catche
  module Expire
    module Page

      class << self

        def expire!(*paths)
          paths.each do |path|
            File.delete(path) if File.exist?(path)
            File.delete(path + '.gz') if File.exist?(path + '.gz')
          end
        end

      end

    end
  end
end