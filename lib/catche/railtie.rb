module Catche
  class Railtie < ::Rails::Railtie
    initializer "include.catche" do |app|
      ActionController::Base.send :include, Catche::Controller
      ActiveRecord::Base.send     :include, Catche::Model
    end
  end
end