class ExampleTokenizer
  def initialize(specified_token_extractor, inferred_token_extractor)
    @specified_token_extractor = specified_token_extractor
    @inferred_token_extractor = inferred_token_extractor
  end

  def tokenize(example, specified_tokens)
    @specified_token_extractor.tokenize(example, specified_tokens)
  end
end