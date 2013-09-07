module Egrex
  class MatchResult
    def initialize(matched, parts=[])
      @matched = matched
      @parts = parts
    end

    def ok
      @matched
    end

    def [](index)
      @parts[index]
    end

    def nil?
      true
    end
  end
end