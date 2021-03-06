require_relative 'spec_helper'
require_relative '../lib/where_clause_objectifier'

include Egrex

describe WhereClauseObjectifier do

  describe '#process' do

    describe 'objectification' do

      it 'should replace specifier symbol value with appropriate Specifier' do
        objects = objectifier.process 'a' => :alphabetic
        objects.values.first.should be_a Alphabetic
      end
      it 'should replace multiple specifiers values with appropriate Specifiers' do
        objects = objectifier.process('b' => :alphabetic, 'a' => :digits)
        objects['a'].should be_a Digits
        objects['b'].should be_a Alphabetic
      end
      it 'should leave modifier objects in place' do
        modifier = Modifier.new
        objects = objectifier.process('m' => modifier)
        objects['m'].should be modifier
      end

      it 'should leave specifier objects in place' do
        specifier = Specifier.new
        objects = objectifier.process('s' => specifier)
        objects['s'].should be specifier
      end

      class DummyModifier < RegexModifier
        def modify(specifier)
          "i modified a #{specifier.class}"
        end
      end
      it 'should apply modifier objects to specifier objects in place' do
        modifier = DummyModifier.new
        specifier = Specifier.new
        objects = objectifier.process('s' => [specifier, modifier])
        objects['s'].should eq 'i modified a Egrex::Specifier'
      end
      it 'should apply modifier objects to specifier for explicit symbol in place' do
        modifier = DummyModifier.new
        objects = objectifier.process('s' => [:digits, modifier])
        objects['s'].should eq 'i modified a Egrex::Digits'
      end

      it 'should apply modifier objects for explicit symbol to specifier for explicit symbol in place' do
        objects = objectifier.process('s' => [:literal, :optional])
        objects['s'].should be_a Optional
        objects['s'].to_regex_s.should eq 's?'
      end
    end

    describe 'error handling' do
      it 'should raise error for unknown specifier' do
        expect {
          objectifier.process 'blah' => :some_unknown_specifier
        }
        .to raise_error {|error|
          error.message.should contain ':some_unknown_specifier',
                                'egrex knows about',
                                ':alphabetic',
                                ':digits'
        }
      end

    end
    describe '#one_of' do
      it 'should parse each character of a single string to an Alternatives'
      it 'should parse multiple strings into an Alternatives'
    end
    describe '#may_be' do
      it 'should (handle alternate option)'
      it 'should use #or_else as an alias'
    end
  end
end

def objectifier
  WhereClauseObjectifier.new
end
