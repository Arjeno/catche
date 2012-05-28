module Catche
  class Railtie < ::Rails::Railtie
    initializer "include.catche" do |app|
      Catche.initialize_defaults
    end
  end
end