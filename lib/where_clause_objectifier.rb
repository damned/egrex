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
        raise EgrexError.new("Unknown specifier: #{specifier.inspect} - egrex knows about:\n#{symbols_list known_specifiers}")
      end
      known_specifiers[specifier].new
    end

    def known_specifiers
      {
          alphabetic: Alphabetic,
          digits: Digits
      }
    end

    def symbols_list(symbols)
      symbols.collect(&:inspect).join(', ')
    end
  end
end