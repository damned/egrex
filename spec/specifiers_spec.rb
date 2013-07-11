require_relative 'spec_helper'
require_relative '../lib/egrex'

include Egrex


describe 'specifiers' do
  describe Alphabetic do
    it 'should match any number of chars' do
      alphabetic.match('abc')[0].should eq 'abc'
      alphabetic.match('a')[0].should eq 'a'
      alphabetic.match('abadsfadsfasd')[0].should eq 'abadsfadsfasd'
    end

    it 'should not match empty string' do
      alphabetic.match('').should be_false
    end

    it 'should not match if has no alphabetics' do
      alphabetic.match('1').should be_false
      alphabetic.match('777799').should be_false
    end

    it 'should match first alphabetic sequence if has any alphabetics' do
      alphabetic.match('foo bar')[0].should eq 'foo'
      alphabetic.match('8foo9bar')[0].should eq 'foo'
      alphabetic.match('7777q9')[0].should eq 'q'
    end
  end

  describe Digits do
    it 'should match if there are number of digits as subject' do
      digits = Digits.new('123')

      digits.match('987')[0].should eq '987'
    end

    it 'should not match if there are at least same number of digits as subject' do
      digits = Digits.new('123')

      digits.match('7').should be_false
    end

    it 'should not match if there are more digits than subject' do
      digits = Digits.new('123')

      digits.match('7778').should be_false
    end
  end

  describe Literal do
    it 'should match the exact same literal' do
      literal = Literal.new('a')
      literal.match('a')[0].should eq 'a'
    end
    it 'should match the same sequence of literals' do
      literals = Literal.new('a-b-c')
      literals.match('a-b-c')[0].should eq 'a-b-c'
    end
    it 'should not match different letters' do
      literals = Literal.new('a-b-c')
      literals.match('x-y-z').should be_false
    end
  end

  describe 'Modifiers:' do
    describe Optional do
      xit 'should modify a specifier to make it optional' do
        modified = Optional.new.modify(Literal.new('a'))
        modified.match('a')[0].should eq 'a'
        modified.match('')[0].should be ''
        modified.match('b')
      end
    end
  end
end

def alphabetic
  /#{Alphabetic.new.to_regex_s}/
end
