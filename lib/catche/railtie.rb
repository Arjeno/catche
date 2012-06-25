module Catche
  class Railtie < ::Rails::Railtie
    initializer "include.catche" do |app|
      ActionController::Base.send :include, Catche::Controller
      ActiveRecord::Base.send     :include, Catche::Model
      ActionView::Base.send       :include, Catche::ViewHelpers
    end
  end
end