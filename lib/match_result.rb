module Egrex
  class MatchResult
    def initialize(matched)
      @matched = matched
    end
    def ok
      @matched
    end
    def nil?
      !ok
    end
  end
  class Matched < MatchResult
    def initialize(parts)
      super(true)
      @parts = parts
    end
    def [](index)
      @parts[index]
    end
  end
  class MatchFailed < MatchResult
    attr_reader :description
    def initialize(description = 'no more info')
      super(false)
      @description = description
    end
  end
end