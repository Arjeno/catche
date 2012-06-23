require 'catche/expire/view'
require 'catche/expire/page'

module Catche
  module Expire

    class << self

      def expire!(data)
        Catche::Expire::View.expire! *data[:views]
        Catche::Expire::Page.expire! *data[:pages]
      end

    end

  end
end