require 'rspec'
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
end
