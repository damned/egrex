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

    def infer_specifier(part, &handler)
      trace "part: #{part}"
      return if match_part(handler, part, /^[[:digit:]]+/, :digits)
      return if match_part(handler, part, /^[[:alpha:]]+/, :alphabetic)
      match_part(handler, part, /^[^[:alpha:][:digit:]]+/, :literal)
    end

    def match_part(match_handler, part, matcher, type)
      chars = part.size
      match = matcher.match part
      if match
        match_handler.call match[0], type
        trace "match 0: #{match[0]}"
        if (match[0].size < chars)
          infer_specifier(part.slice(match[0].size, part.size), &match_handler)
        end
        true
      else
        false
      end
    end
  end
end