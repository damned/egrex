require_relative 'egrex_error'
require_relative 'egrex'
require_relative 'log'

module Egrex
  class WhereClauseObjectifier
    include Log

    def process(symbols)
      specs = {}
      symbols.each_pair { |part, specifier|
        specifiers = to_array_modifiers_last(specifier)
        specs[part] = objectify(part, specifiers)
      }
      specs
    end

    private
    def to_array_modifiers_last(specifier)
      specifiers = [specifier]
      modifiers = specifiers.flatten.select { |spec|
        is_modifier(spec)
      }
      non_modifiers = specifiers.flatten.select { |spec|
        is_non_modifier(spec)
      }
      non_modifiers + modifiers
    end

    def is_non_modifier(spec)
      !is_modifier(spec)
    end

    def is_modifier(spec)
      spec == :optional
    end

    def objectify(subject, specifiers)
      spec_object = nil
      specifiers.each do |specifier|
        if specifier.is_a?(Specifier)
          spec_object = specifier
          next
        end
        if specifier.is_a?(Modifier)
          if spec_object
            spec_object = specifier.modify(spec_object)
            next
          else
            spec_object = specifier
            next
          end
        end
        unless known_specifiers.has_key? specifier
          raise EgrexError.new("Unknown specifier: #{specifier.inspect} - egrex knows about: #{known_specifiers.keys}")
        end

        type = known_specifiers[specifier]
        trace "objectifying #{specifier} to #{type}"
        this_spec = type.new(subject)
        if spec_object
          if this_spec.is_a?(Modifier)
            spec_object = this_spec.modify(spec_object)
          else
            raise EgrexError.new "Can't apply a non-Modifier (#{this_spec}) to existing spec object (#{spec_object})"
          end
        else
          spec_object = this_spec
        end
      end
      spec_object
    end

    def known_specifiers
      {
          alphabetic: Alphabetic,
          digits: Digits,
          literal: Literal,
          optional: Optional
      }
    end
  end
end