require_relative 'spec_helper'
require_relative '../lib/egrex'

include Egrex


describe 'specifiers' do
  describe Alphabetic do
    it 'should match any number of chars' do
      Alphabetic.new.match('abc')[0].should eq 'abc'
      Alphabetic.new.match('a')[0].should eq 'a'
      Alphabetic.new.match('abadsfadsfasd')[0].should eq 'abadsfadsfasd'
    end

    it 'should not match empty string' do
      Alphabetic.new.match('').should be_false
    end

    it 'should not match if has no alphabetics' do
      Alphabetic.new.match('1').should be_false
      Alphabetic.new.match('777799').should be_false
    end

    it 'should not match if only starts with alphabetic sequence' do
      Alphabetic.new.match('foo9').should be_false
    end

    it 'should not match if only ends with alphabetic sequence' do
      Alphabetic.new.match('8foobar').should be_false
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
      it 'should modify a literal to make it optional' do
        modified = Optional.new.modify(Literal.new('a'))
        modified.match('a')[0].should eq 'a'
        modified.match('')[0].should eq ''
        modified.match('b')
      end
      it 'should modify an albhabetic string matcher to make it optional' do
        modified = Optional.new.modify(Alphabetic.new('whatever'))
        modified.match('abacsdkjf')[0].should eq 'abacsdkjf'
        modified.match('')[0].should eq ''
        modified.match('1').should be_false
      end
    end
  end
end

