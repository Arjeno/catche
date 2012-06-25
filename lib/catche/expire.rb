require 'catche/expire/views'
require 'catche/expire/pages'

module Catche
  module Expire

    class << self

      def expire!(data)
        Catche::Expire::Views.expire! *data[:views]
        Catche::Expire::Pages.expire! *data[:pages]
      end

    end

  end
end