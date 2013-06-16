require_relative 'egrex_error'
require_relative 'egrex'

module Egrex
  class WhereClauseObjectifier
    def process(symbols)
      specs = {}
      symbols.each_pair { |part, specifier|
        specs[part] = objectify(specifier)
      }
      specs
    end

    private

    def objectify(specifier)
      unless known_specifiers.has_key? specifier
        raise EgrexError.new("Unknown specifier: #{specifier.inspect} - egrex knows about: #{known_specifiers.keys}")
      end
      known_specifiers[specifier].new
    end

    def known_specifiers
      {
          alphabetic: Alphabetic,
          digits: Digits,
          optional: Optional
      }
    end
  end
end