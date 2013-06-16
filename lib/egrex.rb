require_relative 'example_tokenizer'
require_relative 'specified_token_extractor'
require_relative 'inferred_token_extractor'

module Egrex

  class Example
    def initialize(example, where)
      @example = example
      @where = where
    end
    def match(s)
      raise 'oops'
    end
    def compile
      tokenizer = ExampleTokenizer.new(SpecifiedTokenExtractor.new, InferredTokenExtractor.new)
      tokens, specs = tokenizer.tokenize(@example, @where)
      self
    end
    def show
      puts 'nothing here...'
      self
    end
  end

  class Specifier
    def compile
      'should return a regex?'
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
