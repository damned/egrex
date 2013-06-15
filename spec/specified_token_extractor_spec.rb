require 'rspec'
require 'rspec/matchers'
require_relative '../lib/specified_token_extractor'

describe 'SpecifiedTokenExtractor' do
  it 'should associate specified tokens with their specifiers in an all-specified example string' do
    tokens, token_specifications = SpecifiedTokenExtractor.new.tokenize('someexample', {
        'some' => :a_specifier,
        'example' => :another_specifier
    })

    tokens.should eq(['some', 'example'])
    token_specifications.should include('some' => :a_specifier,
                                        'example' => :another_specifier)
  end

  it "should return tokens ordered by their names' location in example, regardless of specifiers ordering" do
    tokens, token_specifications = SpecifiedTokenExtractor.new.tokenize('FirstSecond', {
        'Second' => :a_specifier,
        'First' => :another_specifier
    })

    tokens.should eq(['First', 'Second'])
    token_specifications.should include({'First' => :another_specifier,
                                         'Second' => :a_specifier})
  end

  it 'should include of example not matched by specifier names as nil-valued specifiers' do
    tokens, token_specifications = SpecifiedTokenExtractor.new.tokenize('FirstUnspecifiedLast', {
        'First' => :a_specifier,
        'Last' => :another_specifier
    })

    token_specifications.should include('Unspecified' => nil)
  end

  it 'should order a mix of specified and unspecified tokens as in example string' do
    tokens, specs = SpecifiedTokenExtractor.new.tokenize('FirstUnspecifiedLast', {
        'st' => :a_specifier,
        'La' => :another_specifier
    })

    tokens.should eq(['Fir', 'st', 'Unspecified', 'La', 'st'])
  end
end
