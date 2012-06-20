module Catche
  module Model
    module Base
      extend ActiveSupport::Concern

      included do
        after_update  :expire_resource_and_collection!
        after_destroy :expire_resource_and_collection!

        after_create  :expire_collection!
      end

      def expire_resource_and_collection!
        expire_collection!
        expire_resource!
      end

      def expire_collection!
        expire_cache! false
      end

      def expire_resource!
        expire_cache!
      end

      def expire_cache!(set_instance=true)
        tags = Catche::Tag::Object.find_by_model(self.class).collect do |obj|
          self.instance_variable_set("@#{obj.options[:resource_name]}", self) if set_instance
          obj.expiration_tags(self)
        end.flatten.compact.uniq

        Catche::Tag.expire! *tags
      end

    end
  end
end

ActiveRecord::Base.send :include, Catche::Model::Base