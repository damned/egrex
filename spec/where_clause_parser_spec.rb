require 'rspec'
require_relative '../lib/where_clause_parser'

describe WhereClauseParser do
  describe '#parse' do
    it 'should return an empty hash for an empty where hash'
    it 'should return hash of specified element name to specifier'
    it 'should use TypeHeuristics to determine the the type of an element with no specifier'
    describe '#one_of' do
      it 'should parse each character of a single string to an Alternatives'
      it 'should parse each character of a single string to an Alternatives'
    end
    describe '#may_be' do
      it 'should (handle alternate option)'
      it 'should use #or_else as an alias'
    end
  end
end

