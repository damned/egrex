require_relative 'log'
require_relative 'match_result'

module Egrex

  class Part
    def initialize(str = '')
      @str = str
    end
    def matches?(other)
      if integer?
        other.integer?
      else
        @str == other.to_s
      end
    end
    def integer?
      @str.to_i.to_s == @str
    end
    def to_s
      @str
    end
    def is_in?(set)
      set.include? @str
    end
  end

  class Parts
    def initialize(str)
      @str = str
      @parts = str.chars.collect {|c| Part.new c}
      @next_index = 0
    end
    def size
      @str.size
    end
    def parts
      @parts
    end
    def peek
      @parts[@next_index]
    end
    def any_left?
      !peek.nil?
    end
    def next
      @next_index += 1
      @parts[@next_index - 1]
    end
  end

  class Where
    def initialize(specifier_hash)
      @hash = specifier_hash
    end
    def [](part_key)
      @hash[part_key.to_s]
    end
  end

  class Example
    include Log
    def initialize(example, where)
      @example = Parts.new(example)
      @where = Where.new(where)
    end
    def match(s)
      return result(false) if s.size > @example.size
      parts = Parts.new(s)

      matched = @example.parts.all? { |example_part|
        part = parts.any_left? ? parts.peek : Part.new
        specifier = @where[example_part]
        if specifier
          if specifier.is_a? Set
            part_matches = part.is_in? specifier
          elsif specifier == :optional
            part_matches = example_part.matches? part
          else
            raise "don't know what this where specifier is: '#{specifier}''"
          end
        else
          part_matches = example_part.matches? part
        end

        if part_matches
          parts.next
        elsif did_not_match_but_was_optional(example_part)
          part_matches = true
        end
        part_matches
      }
      return result(false) if parts.any_left?
      result(matched, [s])
    end

    def did_not_match_but_was_optional(example_part)
      @where[example_part] == :optional
    end

    def result(matched, parts = [])
      MatchResult.new matched, parts
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
