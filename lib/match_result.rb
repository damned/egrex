module Egrex
  class MatchResult
    def initialize(matched)
      @matched = matched
    end

    def ok
      @matched
    end
  end
end