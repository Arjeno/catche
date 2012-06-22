require 'catche/expire/view'

module Catche
  module Expire

    class << self

      def expire!(data)
        Catche::Expire::View.expire! *data[:views]
      end

    end

  end
end