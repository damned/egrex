require_relative 'log'
require_relative 'match_result'

module Egrex

  class Part
    def initialize(str)
      @str = str
    end
    def matches?(str)
      @str == str
    end
    def to_s
      @str
    end
  end

  class Parts
    def initialize(str)
      @str = str
    end
    def size
      @str.size
    end
    def parts
      @str.chars.collect {|c| Part.new c}
    end
  end

  class Example
    include Log
    def initialize(example, where)
      @example = Parts.new(example)
      @where = where
    end
    def match(s)
      return result(false) if s.size > @example.size
      chars = s.chars

      matched = @example.parts.all? { |example_part|
        char = remaining_chars?(chars) ? chars.peek : ''
        specifier = @where[example_part.to_s]
        if specifier
          if specifier.is_a? Set
            char_matches = specifier.include?(char)
          elsif specifier == :optional
            char_matches = part_matches?(char, example_part)
          else
            raise "don't know what this where specifier is: '#{specifier}''"
          end
        else
          char_matches = part_matches?(char, example_part)
        end

        if char_matches
          chars.next
        elsif did_not_match_but_was_optional(example_part)
          char_matches = true
        end
        char_matches
      }
      return result(false) if remaining_chars?(chars)
      result(matched, [s])
    end

    def part_matches?(char, example_part)
      if example_part.matches? '-'
        part_matches = char == '-'
      else
        part_matches = is_integer(char)
      end
      part_matches
    end

    def remaining_chars?(chars_enum)
      begin
        chars_enum.peek
        true
      rescue StopIteration
        false
      end
    end

    def did_not_match_but_was_optional(example_part)
      @where[example_part.to_s] == :optional
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

  def one_of(*chars)
    if chars.size == 1
      Set.new(chars[0].chars)
    else
      Set.new(chars)
    end
  end

  def eg(example, where = {})
    Example.new(example, where).compile
  end

end
