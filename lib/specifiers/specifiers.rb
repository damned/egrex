require_relative 'matchable'
require_relative '../log'

module Egrex
  Specifiers = Set.new [:digits, :alphabetic, :literal]
  Modifiers = Set.new [:optional]

  class Specifier
    include Log
    def initialize(subject='')
      @subject = subject
    end
  end

  class RegexSpecifier < Specifier
    include Matchable
    def to_regex_s
      'should return a regex snippet string'
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
  class Modifier
    include Log
    def initialize(subject='')
      @subject = subject
    end
    def modify(specifier)

    end
  end

  class RegexModifier < Modifier
    include Matchable
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

    private
    def plural
      @unmodified.end_with? '+'
    end
  end

end