
module EgrexOld

  warn "EgrexOld's days are numbered, working on Egrex implementation"

  class Example
    def initialize(example, where)
      @example = example
      @where = where
    end
    def match(s)
      @pattern.match(s)
    end
    def tokenize(s)
      s.chars
    end
    def compile
      pattern = ''

      tokenize(@example).each { |token|
        case token
        when /\d/
          pattern << '\d'
        else
          pattern << specified(token)
        end
      }
      @pattern = /^#{pattern}$/
      self
    end
    def show
      puts "pattern: #{@pattern}"
      self
    end
    private

    def specified(c)
      specification = c
      if @where.has_key? c
        specifier = @where[c]
        if specifier == :optional
          specification = c + '?'
        elsif specifier.class <= Specifier
          specification = specifier.compile
        else
          raise "Unknown specifier: #{specifier}"
        end
      end
      specification
    end
  end

  class Specifier
    def compile
      'should return a regex'
    end
  end

  class Literals < Specifier
    def initialize(literals)
      @literals = literals
    end

    def compile
      to_regex(@literals)
    end
    private

    def to_regex(literals)
      regex = literals.chars.collect { |literal|
        if '.'.include? literal
          return "\\#{literal}"
        end
        literal
      }.join
      puts "literals regex: #{regex}"
      /#{regex}/
    end
  end

  class May < Specifier
    def be(specifier)
      @alternate_specifier = specifier
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
    Literals.new(chars)
  end

  def eg(example, where = {})
    Example.new(example, where).compile
  end
  
end
