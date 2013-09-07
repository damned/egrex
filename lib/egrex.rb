require_relative 'log'
require_relative 'match_result'

module Egrex

  class Example
    include Log
    def initialize(example, where)
      @example = example
      @where = where
    end
    def match(s)
      return result(false) if s.size > @example.size
      chars = s.chars

      matched = @example.chars.all? { |example_char|
        char = remaining_chars?(chars) ? chars.peek : ''
        if example_char == '-'
          char_matches = char == '-'
        else
          char_matches = is_integer(char)
        end
        if char_matches
          chars.next
        elsif did_not_match_but_was_optional(example_char)
          char_matches = true
        end
        char_matches
      }
      return result(false) if remaining_chars?(chars)
      result(matched, [s])
    end

    def remaining_chars?(chars_enum)
      begin
        chars_enum.peek
        true
      rescue StopIteration
        false
      end
    end

    def did_not_match_but_was_optional(example_char)
      @where[example_char] == :optional
    end

    def result(matched, parts = [])
      MatchResult.new matched, parts
    end

    def is_integer(s)
      s.to_i.to_s == s
    end

    def compile
      self
    end
    def show
      log 'nothing here...show not implemented yet in new egrex'
      self
    end
  end

  class May
    def be(specifier)
      self
    end
  end

  def optional
    :optional
  end

  def may
    May.new
  end

  def one_of(chars)
  end

  def eg(example, where = {})
    Example.new(example, where).compile
  end

end
