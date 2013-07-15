require_relative 'spec_helper'
require_relative '../lib/compound_token_extractor'

describe CompoundTokenExtractor do
  context 'where one specified token contains another' do
    it 'should not extract tokens from input string' do
      tokens, specs = CompoundTokenExtractor.new.tokenize(['someexample'], {
          'some' => :a_specifier
      })
      tokens.should eq(['someexample'])
    end
    it 'should convert overlapping specs to compound token specs' do
      tokens, specs = CompoundTokenExtractor.new.tokenize('someexample', {
          'some' => :a_specifier,
          'someex' => :another_specifier
      })
      specs.should eq 'someex' => [ :another_specifier, { 'some' => :a_specifier}]
    end

    it 'should convert overlapping specs to compound token specs when sub-token follows token' do
      tokens, specs = CompoundTokenExtractor.new.tokenize('someexample', {
          'someex' => :another_specifier,
          'some' => :a_specifier
      })
      specs.should eq 'someex' => [ :another_specifier, { 'some' => :a_specifier}]
    end
    it 'should convert multiple compound token specs' do
      tokens, specs = CompoundTokenExtractor.new.tokenize('someexample', {
          'someex' => :outer_specifier,
          'some' => :inner_specifier,
          'amp' => :another_inner_specifier,
          'ample' => :another_outer_specifier,
      })
      specs.should eq 'someex' => [ :outer_specifier, { 'some' => :inner_specifier}],
                       'ample' => [ :another_outer_specifier, { 'amp' => :another_inner_specifier}]
    end

    it 'should convert where sub-token used in multiple tokens' do
      tokens, specs = CompoundTokenExtractor.new.tokenize('someexample', {
          'm' => :inner_specifier,
          'some' => :a_specifier,
          'example' => :another_specifier
      })
      specs.should eq 'some' => [ :a_specifier, { 'm' => :inner_specifier}],
                      'example' => [ :another_specifier, { 'm' => :inner_specifier}]
    end

    it 'should convert where multiple sub-tokens are used in a token'

    it 'should not change specs if no overlap in tokens' do
      tokens, specs = CompoundTokenExtractor.new.tokenize('someexample', {
          'some' => :a_specifier,
          'example' => :another_specifier
      })
      specs.should eq 'some' => :a_specifier, 'example' => :another_specifier
    end
  end
end