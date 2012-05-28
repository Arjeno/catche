require 'catche/tag/controller'
require 'catche/tag/resource'

module Catche
  module Tag

    DIVIDER = '_'

    extend self

    def join(*tags)
      tags.flatten.compact.uniq.join(self::DIVIDER)
    end

  end
end