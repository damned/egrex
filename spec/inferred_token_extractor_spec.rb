require 'rspec'
require_relative '../lib/inferred_token_extractor'

describe InferredTokenExtractor do
  def extractor
    InferredTokenExtractor.new
  end
  it 'should infer token as alphabetic if consists of consecutive alphabetic characters' do
    tokens, specs = extractor.tokenize('blah')
    tokens.should eq ['blah']
    specs.should eq('blah' => :alphabetic)
  end
  it 'should infer token as numeric if consists of consecutive number digits' do
    tokens, specs = extractor.tokenize('123')
    tokens.should eq ['123']
    specs.should eq('123' => :digits)
  end
  it 'should not override specifiers' do
    tokens, specs = extractor.tokenize 'blah', { 'blah' => :digits }
    specs['blah'].should eq :digits
  end

  it 'should infer specifiers for an array of mixed tokens' do
    tokens, specs = extractor.tokenize ['blah', '123', 'bar']
    tokens.should eq ['blah', '123', 'bar']
    specs.should eq('blah' => :alphabetic, '123' => :digits, 'bar' => :alphabetic)
  end

  it 'should infer specifiers for tokens without specifiers when there is a mix' do
    tokens, specs = extractor.tokenize ['blah1', 'foo', 'bar', '123'], 'bar' => :digits, 'blah1' => :alphabetic
    tokens.should eq ['blah1', 'foo', 'bar', '123']
    specs.should eq('blah1' => :alphabetic, 'foo' => :alphabetic, 'bar' => :digits, '123' => :digits)
  end
end
