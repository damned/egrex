require 'rspec'
require 'rspec/mocks'
require_relative '../lib/example_tokenizer'


describe ExampleTokenizer do
  describe '#tokenize' do
    before :each do
      @extractors = [double('first extractor'), double('second extractor')]
      @example_tokenizer = ExampleTokenizer.new(*@extractors)
      @specifier = double('Specifier')
      @another_specifier = double('Specifier')
    end

    it 'should pass ' do
      specified_tokens = {
          'some' => @specifier,
          'example' => @another_specifier
      }

      @extractors[0].should_receive(:tokenize).
          with(['someexample'], specified_tokens).
          and_return([['some', 'example'], specified_tokens ])
      stub_to_pass_through(@extractors[1])

      tokens, token_specifications = @example_tokenizer.tokenize('someexample', {
          some: @specifier,
          example: @another_specifier
      })

      tokens.should eq(['some', 'example'])
      token_specifications.should eq(specified_tokens)
    end

    it 'should extract unspecified, inferred tokens if composed entirely of inferred tokens' do
      @extractors[0].stub(tokenize: [ ['testcase'], { } ])
      @extractors[1].stub(tokenize: [ ['testcase'], { 'testcase' => :some_specifier } ])

      tokens, token_specifications = @example_tokenizer.tokenize('testcase', {})

      tokens.should eq(['testcase'])
      token_specifications.should eq('testcase' => :some_specifier)
    end

    it 'should extract a mix of specified and inferred tokens'
  end
end

def stub_to_pass_through(extractor)
  extractor.stub(:tokenize) do |tokens, specified|
    [tokens, specified]
  end
end

describe 'SpecifiedTokenExtractor' do
  it 'should find specified tokens in an example string'
end

describe 'InferredTokenExtractor' do
  it 'should infer tokens in example based on heuristic of consecutive characters of the same type'
  it 'should tokenize an array of multiple example parts into an array of token strings'
end

