require 'catche/tag/object'
require 'catche/tag/resource'

module Catche
  module Tag

    KEY     = 'catche'
    DIVIDER = '_'

    extend self

    def join(*tags)
      tags.flatten.compact.uniq.join(DIVIDER)
    end

    def tag!(key, *tags)
      tags.each do |tag|
        keys      = fetch_tag(tag)
        key_tags  = fetch_key(key)
        tag_key   = stored_key(:tags, tag)
        key_key   = stored_key(:keys, key)

        Catche.adapter.write(tag_key, keys << key)
        Catche.adapter.write(key_key, key_tags << tag_key)
      end
    end

    def expire!(*tags)
      expired_keys = []

      tags.each do |tag|
        keys = fetch_tag(tag)
        expired_keys += keys

        keys.each do |key|
          # Expires the cached value
          Catche.adapter.delete key

          # Removes the tag from the tag list in case it's never used again
          Catche.adapter.write(
              stored_key(:keys, key),
              fetch_key(key).delete(stored_key(:tags, tag))
            )
        end

        Catche.adapter.delete stored_key(:tags, tag)
      end

      expired_keys
    end

    protected

      def fetch_tag(tag)
        Catche.adapter.read stored_key(:tags, tag), []
      end

      def fetch_key(key)
        Catche.adapter.read stored_key(:keys, key), []
      end

      def stored_key(scope, value)
        join_keys KEY, scope.to_s, value.to_s
      end

      def join_keys(*keys)
        keys.join('.')
      end

  end
end