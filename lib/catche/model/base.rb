module Catche
  module Model
    module Base
      extend ActiveSupport::Concern

      included do
        class_attribute :catche_class,
                        :catche_collection_tag,
                        :catche_tag_identifier,
                        :catche_associations

        # Expiration callbacks

        after_update  :expire_resource_and_collection!
        after_destroy :expire_resource_and_collection!

        after_create  :expire_collection!
      end

      module ClassMethods

        # Configures catche
        #
        #   catche :through => :project, :catche_class => Task
        def catche(options={})
          options = {
            :class          => self,
            :tag_identifier => :id,
            :collection_tag => nil,
            :associations   => [options[:through]].flatten.compact
          }.merge(options)

          options.each do |key, value|
            self.send("catche_#{key}=", value) if self.respond_to?("catche_#{key}")
          end

          self.catche_collection_tag ||= self.catche_class.name.downcase.pluralize
        end

        def catche_reset!
          catche {}
        end

        def catche_tag
          self.catche_collection_tag || self.name.downcase.pluralize
        end

        def catche_tag=(value)
          self.catche_collection_tag = value
        end

        def catche_tag_identifier
          super || :id
        end

      end

      def catche_tag
        Tag.join self.class.catche_tag, self.send(:id)
      end

      def expire_resource_and_collection!
        expire_collection!
        expire_resource!
      end

      def expire_collection!
        Catche::Tag.expire! *Catche::Tag::Collect.collection(self, self.class)[:expire]
      end

      def expire_resource!
        Catche::Tag.expire! *Catche::Tag::Collect.resource(self)[:expire]
      end

    end
  end
end

ActiveRecord::Base.send :include, Catche::Model::Base