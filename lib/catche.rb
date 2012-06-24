require 'catche/railtie'
require 'catche/adapter'
require 'catche/controller'
require 'catche/model'
require 'catche/tag'
require 'catche/resource_loader'
require 'catche/expire'

module Catche

  extend self

  def initialize_defaults
    
  end

  def adapter
    Catche::Adapter::Base
  end

end
