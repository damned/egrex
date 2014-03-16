require_relative 'log'
require_relative 'match_result'
require_relative 'where'

module Egrex

  class Part
    def initialize(str = '')
      @str = str
    end

    # todo this behaviour is default matching behaviour
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

  class ExamplePart < Part
    def initialize(str = '', specifier = nil)
      super(str)
      @specifier = specifier
    end
    def matches?(part)
      if @specifier
        if @specifier.is_a? Set
          part.is_in? @specifier
        elsif optional?
          super part
        elsif @specifier.is_a? Specifier
          @specifier.matches? part
        else
          raise "don't know what this where specifier is: '#{@specifier}''"
        end
      else
        super part
      end
    end
    def optional?
      @specifier == :optional
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
      return @parts[@next_index] if any_left?
      Part.new
    end
    def any_left?
      @next_index < size
    end
    def remainder
      any_left? ? @parts.slice(@next_index..-1).join : ''
    end
    def next
      @next_index += 1
      @parts[@next_index - 1]
    end
  end

  class ExampleParts < Parts
    def initialize(str, where = Where.new)
      super(str)
      @parts = where.split(str).collect {|token| ExamplePart.new(token, where[token])}
      @where = where
    end
  end

  class Example
    include Log
    def initialize(example, where)
      @where = Where.new(where)
      @example = ExampleParts.new(example, @where)
    end
    def match(s)
      parts = Parts.new(s)

      matched = @example.parts.all? { |example_part|
        part = parts.peek

        if example_part.matches?(part)
          parts.next
        else
          example_part.optional?
        end
      }
      if parts.any_left?
        MatchFailed.new "Whole string not matched: '#{parts.remainder}' still left"
      else
        result(matched, [s])
      end
    end

    def result(matched, parts = [])
      if matched
        Matched.new parts
      else
        MatchFailed.new
      end
    end

    def compile
      self
    end
    def show
      log 'nothing here...show not implemented yet in new egrex'
      self
    end
  end

  class Specifier

  end

  class May < Specifier
    def be(specifier)
      self
      @specifier = specifier
    end
    def matches?(part)
      part == @specifier
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
