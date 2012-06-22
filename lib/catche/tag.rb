require 'catche/tag/collect'

module Catche
  module Tag

    KEY     = 'catche'
    DIVIDER = '_'

    extend self

    def join(*tags)
      tags.flatten.compact.uniq.join(DIVIDER)
    end

    # Tags a view
    def tag_view!(view, *tags)
      tag_type! :views, view, *tags
    end
    alias :tag_fragment! :tag_view!

    # Tags a page cache
    def tag_page!(page, *tags)
      tag_type! :pages, page, *tags
    end

    # Dynamic method for tagging a type of stored cache
    #
    #   Catche::Tag.tag_type!(:views, 'example.com/projects', 'projects')
    def tag_type!(scope, value, *tags)
      tags.each do |tag|
        data      = fetch_tag(tag)

        # Set up key names
        tag_key   = stored_key(:tags, tag)
        type_key  = stored_key(scope, value)

        # Current tags
        type_tags = fetch_type(scope, value)

        # Append new value to scoped data
        data[scope] ||= []
        data[scope] << value
        tag_data  = data

        # Append new tag key
        type_data = type_tags << tag_key

        Catche.adapter.write(tag_key, tag_data)
        Catche.adapter.write(type_key, type_data)
      end
    end

    def expire!(*tags)
      tags.each do |tag|
        Catche::Expire.expire! fetch_tag(tag)
        Catche.adapter.delete stored_key(:tags, tag)
      end
    end

    protected

      def fetch_tag(tag)
        Catche.adapter.read stored_key(:tags, tag), {}
      end

      def fetch_key(key)
        Catche.adapter.read stored_key(:keys, key), []
      end

      def fetch_type(type, value)
        Catche.adapter.read stored_key(type, value), []
      end

      def fetch_path(path)
        Catche.adapter.read stored_key(:paths, path), []
      end

      def stored_key(scope, value)
        join_keys KEY, scope.to_s, value.to_s
      end

      def join_keys(*keys)
        keys.join('.')
      end

  end
end