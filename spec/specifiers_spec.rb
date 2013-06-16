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
end

def alphabetic
  /#{Alphabetic.new.compile}/
end
