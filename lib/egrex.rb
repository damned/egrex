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
      if @example == '-'
        result s == '-'
      else
        result(is_integer(s) && s.length == @example.length)
      end
    end

    def result(matched)
      MatchResult.new matched
    end

    def is_integer(s)
      unpadded = s.gsub(/^0+/, '')
      s.to_i.to_s == unpadded
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
