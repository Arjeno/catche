require 'catche/railtie'
require 'catche/adapter'
require 'catche/controller'
require 'catche/model'
require 'catche/tag'
require 'catche/resource_loader'
require 'catche/expire'
require 'catche/view_helpers'

module Catche

  extend self

  class << self

    def adapter
      Catche::Adapter::Base
    end

  end

end
