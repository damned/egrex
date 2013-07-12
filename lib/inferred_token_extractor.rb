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

    # todo: refac
    def infer_specifier(part, &handler)
      trace "part: #{part}"
      chars = part.size
      match = /^[[:digit:]]+/.match part
      if match
        handler.call match[0], :digits
        trace "match 0: #{match[0]}"
        if (match[0].size < chars)
          infer_specifier(part.slice(match[0].size, part.size), &handler)
        end
        return
      end
      match = /^[[:alpha:]]+/.match part
      if match
        trace "match 0: #{match[0]}"
        handler.call match[0], :alphabetic
        if (match[0].size < chars)
          infer_specifier(part.slice(match[0].size, part.size), &handler)
        end
        return
      end
      match = /^[^[:alpha:][:digit:]]+/.match part
      if match
        trace "match 0: #{match[0]}"
        handler.call match[0], :literal
        if (match[0].size < chars)
          infer_specifier(part.slice(match[0].size, part.size), &handler)
        end
        return
      end
    end
  end
end