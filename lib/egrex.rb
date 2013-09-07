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
      return result(false) if s.size != @example.size
      chars = s.chars

      result @example.chars.all? { |example_char|
        char = chars.next
        if example_char == '-'
          char == '-'
        else
          is_integer(char)
        end
      }, [s]
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
