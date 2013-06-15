class ExampleTokenizer
  def initialize(*extractors)
    @tokenizers = extractors
  end

  def tokenize(example, specified_tokens)
    example_parts = [ example ]
    tokens = keys_as_strings(specified_tokens)
    @tokenizers.each do |tokenizer|
      example_parts, tokens = tokenizer.tokenize(example_parts, tokens)
    end
    [ example_parts, tokens ]
  end

  def keys_as_strings(hash)
    newhash = {}
    hash.each { |k, v|
      newhash[k.to_s] = v
    }
    newhash
  end
end