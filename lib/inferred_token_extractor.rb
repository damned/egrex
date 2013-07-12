require_relative 'log'


module Egrex
  class InferredTokenExtractor
    include Log

    def tokenize(example_parts, specifiers = {})
      parts = [example_parts].flatten
      outparts = []
      specs = {}
      add_to_output = lambda { |subpart, specifier|
        outparts << subpart
        specs[subpart] = specifier
      }

      parts.each do |part|
        specifier = specifiers[part]
        if specifier
          add_to_output.call part, specifier
        else
          infer_specifier(part, &add_to_output)
        end
      end

      [ outparts , specs ]
    end

    TYPE_MATCHERS = {
        digits: /^[[:digit:]]+/,
        alphabetic: /^[[:alpha:]]+/,
        literal: /^[^[:alpha:][:digit:]]+/
    }

    def infer_specifier(part, &inference_handler)
      trace "part: #{part}"
      TYPE_MATCHERS.each do |type, matcher|
        return if match_part(inference_handler, part, matcher, type)
      end
    end

    def match_part(match_handler, part, matcher, type)
      chars = part.size
      match = matcher.match part
      return false unless match

      trace "match 0: #{match[0]} (#{type})"
      match_handler.call match[0], type
      if (match[0].size < chars)
        remainder = part.slice(match[0].size, part.size)
        infer_specifier(remainder, &match_handler)
      end
      true
    end
  end
end