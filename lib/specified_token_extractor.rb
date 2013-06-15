require_relative 'string_splitter'

class SpecifiedTokenExtractor
  def tokenize(example='', specifiers={})
    tokens = StringSplitter.new(example).break_with specifiers.keys
    all_tokens_nil_specs = Hash[tokens.map { |token|
      [token,  nil]
    }]
    [ tokens, all_tokens_nil_specs.merge(specifiers) ]
  end
end