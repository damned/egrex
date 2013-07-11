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
    def modify(specifier)

    end
  end

  class RegexModifier < RegexSpecifier
  end

  class Optional < RegexModifier
    def modify(specifier)
      @specifier = specifier
      @unmodified = @specifier.to_regex_s
      self
    end
    def to_regex_s
      # okay probably not the right place for this...
      if plural
        "#{@unmodified.chop}*"
      else
        "#{@unmodified}?"
      end
    end

    def plural
      @unmodified.end_with? '+'
    end
  end

end