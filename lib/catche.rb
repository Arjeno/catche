require 'catche/railtie'
require 'catche/adapter'
require 'catche/controller'
require 'catche/model'
require 'catche/tag'

module Catche

  extend self

  def initialize_defaults
    
  end

  def adapter
    Catche::Adapter::Base
  end

end
