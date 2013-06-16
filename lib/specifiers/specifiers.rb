module Egrex
  class Specifier
    def compile
      'should return a regex?'
    end
  end

  class RegexSpecifier < Specifier
    def compile
      'should return a regex snippet'
    end
  end

  class Alphabetic < RegexSpecifier
    def compile
      '[[:alpha:]]+'
    end
  end

  class Digits < RegexSpecifier
    def compile
      '[[:digit:]]+'
    end
  end

  class Optional < RegexSpecifier
    def compile
      '?'
    end
  end
end