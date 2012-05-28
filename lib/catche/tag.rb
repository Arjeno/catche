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

    def tags
      Catche.adapter.read(KEY, [])
    end

  end
end