module Catche
  module Tag

    DIVIDER = '_'

    extend self

    def join(*tags)
      tags.flatten.compact.uniq.join(self::DIVIDER)
    end

  end
end