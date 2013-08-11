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
      if is_integer(s) && s.length == @example.length
        MatchResult.new true
      else
        MatchResult.new false
      end
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
