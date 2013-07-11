require_relative 'example_tokenizer'
require_relative 'specified_token_extractor'
require_relative 'inferred_token_extractor'
require_relative 'where_clause_objectifier'
require_relative 'specifiers/specifiers'

module Egrex

  class Example
    def initialize(example, where)
      @example = example
      @where = where
    end
    def match(s)
      puts "compiled regex: #{@regex}"
      @regex.match s
    end
    def compile
      tokenizer = ExampleTokenizer.new(SpecifiedTokenExtractor.new, InferredTokenExtractor.new)
      tokens, specs = tokenizer.tokenize(@example, @where)
      specs = WhereClauseObjectifier.new.process(specs)
      regex_string = ''
      specs.each_value { |specifier|
        regex_string += specifier.to_regex_s
      }
      @regex = Regexp.new regex_string
      self
    end
    def show
      puts 'nothing here...'
      self
    end
  end

  class Literal < RegexSpecifier
    def initialize(literals)
      @literals = literals
    end

    def to_regex_s
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
      regex
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
    Literal.new(chars)
  end

  def eg(example, where = {})
    Example.new(example, where).compile
  end

end
