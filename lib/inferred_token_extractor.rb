require 'set'
require_relative 'log'
require_relative 'specifiers/specifiers'

module Egrex
  class InferredTokenExtractor
    include Log

    def tokenize(example_parts, explicit_options = {})
      parts = [example_parts].flatten
      outparts = []
      specs = {}
      add_to_output = lambda { |subpart, specifier|
        outparts << subpart
        specs[subpart] = specifier
      }

      parts.each do |part|
        explicit_option = explicit_options[part]
        if explicit_option && Specifiers.include?(explicit_option)
          add_to_output.call part, explicit_option
        else
          infer_specifier(part, explicit_options, &add_to_output)
        end
      end

      [ outparts , specs ]
    end

    TYPE_MATCHERS = {
        digits: /^[[:digit:]]+/,
        alphabetic: /^[[:alpha:]]+/,
        literal: /^[^[:alpha:][:digit:]]+/
    }

    def infer_specifier(part, explicit_options, &inference_handler)
      trace "part: #{part}"
      TYPE_MATCHERS.each do |type, matcher|
        return if match_part(inference_handler, part, matcher, type, explicit_options)
      end
    end

    def match_part(match_handler, part, matcher, type, explicit_options)
      chars = part.size
      match = matcher.match part
      return false unless match

      matched_part = match[0]
      trace "matched part: #{matched_part} (#{type})"
      match_handler.call matched_part, (explicit_options[matched_part].nil? ? type : [type, explicit_options[matched_part]])
      if (matched_part.size < chars)
        remainder = part.slice(matched_part.size, part.size)
        infer_specifier(remainder, explicit_options, &match_handler)
      end
      true
    end
  end
end