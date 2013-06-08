require 'rspec'
require 'rspec/mocks'
require_relative '../lib/example_tokenizer'
require_relative '../lib/specified_token_extractor'
require_relative '../lib/inferred_token_extractor'

describe ExampleTokenizer do
  describe '#tokenize' do
    before :each do
      @specified_token_extractor = double(SpecifiedTokenExtractor)
      @inferred_token_extractor = double(InferredTokenExtractor)
      @example_tokenizer = ExampleTokenizer.new(@specified_token_extractor, @inferred_token_extractor)
      @specifier = double('Specifier')
      @another_specifier = double('Specifier')
    end

    it 'should extract specified tokens if composed entirely of specified tokens' do
      specified_tokens = {'some' => @specifier, 'example' => @another_specifier}
      @specified_token_extractor.stub(tokenize: specified_tokens)
      @inferred_token_extractor.should_not_receive(:tokenize)
      tokens = @example_tokenizer.tokenize('someexample', {
          some: @specifier,
          example: @another_specifier
      })
      tokens.should be(specified_tokens)
    end

    it 'should extract unspecified, inferred tokens'
    it 'should extract a mix of specified and inferred tokens'
  end
end
describe SpecifiedTokenExtractor do
  it 'should find specified tokens in an example string'
end

describe InferredTokenExtractor do
  it 'should infer tokens in example based on heuristic of consecutive characters of the same type'
  it 'should tokenize an array of multiple example parts into an array of token strings'
end

