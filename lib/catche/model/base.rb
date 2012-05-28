module Catche
  module Model
    module Base
      extend ActiveSupport::Concern

      included do
        after_update  :expire_resource!
        after_destroy :expire_resource!

        after_create  :expire_collection!
        after_destroy :expire_collection!
      end

      def expire_collection!
        expire_cache!
      end

      def expire_resource!
        expire_cache!
      end

      def expire_cache!
        tags = Catche::Tag::Object.find_by_model(self.class).collect do |obj|
          self.instance_variable_set("@#{obj.options[:resource_name]}", self)
          obj.expiration_tags(self)
        end.flatten.compact.uniq

        Catche::Tag.expire! *tags
      end

    end
  end
end

ActiveRecord::Base.send :include, Catche::Model::Base