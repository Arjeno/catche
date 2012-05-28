require 'catche/adapter'
require 'catche/controller'
require 'catche/model'
require 'catche/tag'

module Catche

  extend self

  def adapter
    Catche::Adapter::Base
  end

end
