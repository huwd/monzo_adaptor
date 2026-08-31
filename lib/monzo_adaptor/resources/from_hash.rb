# frozen_string_literal: true

module MonzoAdaptor
  module Resources
    # Shared construction helper for the Data.define-based resource
    # wrappers under MonzoAdaptor::Resources. `extend` this into a
    # Data.define class to get a `.from_hash` constructor that:
    #
    # - accepts a Hash with either String or Symbol keys
    # - defaults any of the class's members missing from the hash to nil
    # - silently ignores any hash keys the class doesn't define
    #
    # This is deliberately separate from Data's own strict `.new(**kwargs)`,
    # which requires every member and rejects unknown keywords — too rigid
    # for wrapping real, possibly-partial or newer-than-this-gem API
    # responses.
    module FromHash
      def from_hash(hash)
        new(**members.to_h { |member| [member, hash.key?(member) ? hash[member] : hash[member.to_s]] })
      end
    end
  end
end
