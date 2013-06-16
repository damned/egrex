require_relative 'string_splitter'

class SpecifiedTokenExtractor
  def tokenize(example, specifiers={})
    example_parts = [example].flatten
    tokens = []

    example_parts.collect do |part|
      tokens = tokens + StringSplitter.new(part).break_with(specifiers.keys)
    end

    all_tokens_nil_specs = Hash[tokens.map { |token|
      [token,  nil]
    }]

    [ tokens, all_tokens_nil_specs.merge(specifiers) ]
  end
end