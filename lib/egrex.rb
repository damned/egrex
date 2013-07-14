require_relative 'example_tokenizer'
require_relative 'specified_token_extractor'
require_relative 'inferred_token_extractor'
require_relative 'where_clause_objectifier'
require_relative 'specifiers/specifiers'
require_relative 'log'

module Egrex

  class Example
    include Log
    def initialize(example, where)
      @example = example
      @where = where
    end
    def match(s)
      @regex.match s
    end
    def compile
      tokenizer = ExampleTokenizer.new(SpecifiedTokenExtractor.new, InferredTokenExtractor.new)
      tokens, specs = tokenizer.tokenize(@example, @where)
      specs = WhereClauseObjectifier.new.process(specs)
      regex_string = ''
      tokens.each { |token|
        specifier = specs[token]
        if specifier.nil?
          raise 'Thats pretty fubar, specifier is nil in ' + specs.inspect
        end
        regex_string += specifier.to_regex_s
      }
      regex_string = "^#{regex_string}$"
      trace "compiled regex: #{regex_string}"
      @regex = Regexp.new regex_string
      self
    end
    def show
      log 'nothing here...'
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
      trace "literals regex: #{regex}"
      regex
    end
  end

  class May < Modifier
    def be(specifier)
      @alternate_specifier = specifier
      self
    end
    def modify(specifier)
      @initial_specifier = specifier
    end
    def to_regex_s
      'blah blah blah'
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
