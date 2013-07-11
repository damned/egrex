module Egrex
  class Specifier
    def initialize(subject='')
      @subject = subject
    end
  end

  class RegexSpecifier < Specifier
    def to_regex_s
      'should return a regex snippet string'
    end
    def match(s)
      /^#{to_regex_s}$/.match(s)
    end
  end

  class Alphabetic < RegexSpecifier
    def to_regex_s
      '[[:alpha:]]+'
    end
  end

  class Digits < RegexSpecifier
    def to_regex_s
      "[[:digit:]]{#{@subject.length}}"
    end
  end

  # modifiers passed to all non-modifiers
  class Modifier < Specifier
  end

  class Optional < Modifier
  end

end