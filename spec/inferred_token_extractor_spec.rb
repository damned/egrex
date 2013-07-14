require_relative 'spec_helper'
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

  it 'should infer an alphabetic token followed by a numeric token' do
    tokens, specs = extractor.tokenize('abc123')
    tokens.should eq ['abc', '123']
    specs.should eq('abc' => :alphabetic, '123' => :digits)
  end

  it 'should infer token as literal if not consecutive digits or alphabetics' do
    tokens, specs = extractor.tokenize('123-456')
    tokens.should eq ['123', '-', '456']
    specs.should include('-' => :literal)
  end

  it 'should infer repeated tokens' do
    tokens, specs = extractor.tokenize('123-123-123')
    tokens.should eq ['123', '-', '123', '-', '123']
    specs.should include('-' => :literal, '123' => :digits)
  end

  it 'should not override explicit specifiers' do
    tokens, specs = extractor.tokenize 'blah', { 'blah' => :digits }
    specs['blah'].should eq :digits
  end

  it 'should apply explicit modifier to inferred specifier (alphabetic, optional)' do
    tokens, specs = extractor.tokenize 'abc', { 'abc' => :optional }
    specs['abc'].should include :alphabetic, :optional
  end

  it 'should apply explicit modifier to inferred specifier (digits, optional)' do
    tokens, specs = extractor.tokenize '123', { '123' => :optional }
    specs['123'].should include :digits, :optional
  end

  it 'should infer specifiers for an array of mixed tokens' do
    tokens, specs = extractor.tokenize ['blah', '123', 'bar']
    tokens.should eq ['blah', '123', 'bar']
    specs.should eq('blah' => :alphabetic, '123' => :digits, 'bar' => :alphabetic)
  end

  it 'should infer specifiers for tokens without specifiers when there is a mix' do
    tokens, specs = extractor.tokenize ['blah2', 'foo', 'bar', '123'], 'bar' => :digits, 'blah2' => :alphabetic
    tokens.should eq ['blah2', 'foo', 'bar', '123']
    specs.should eq('blah2' => :alphabetic, 'foo' => :alphabetic, 'bar' => :digits, '123' => :digits)
  end

  it 'should infer extra specifiers for token which has an explicit modifier' do
    tokens, specs = extractor.tokenize ['foo-bar'], '-' => :optional
    tokens.should eq ['foo', '-', 'bar']
    specs.should include('-' => [:literal, :optional])
  end

  it 'should infer extra specifiers for token which has an explicit modifier' do
    tokens, specs = extractor.tokenize ['foo-bar'], '-' => :optional
    tokens.should eq ['foo', '-', 'bar']
    specs.should include('-' => [:literal, :optional])
  end

end
