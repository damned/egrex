require 'rspec'
require_relative '../lib/string_splitter'

# todo remove StringSplitter
describe StringSplitter do

  it 'should split string at token, including the token' do
    splitter = StringSplitter.new 'somelongstring'

    splitter.break_with(['long']).should eq ['some', 'long', 'string']
  end

  it 'should return original string if no tokens specified' do
    splitter = StringSplitter.new 'somelongstring'

    splitter.break_with([]).should eq ['somelongstring']
  end

  it 'should return original string if token not present in string' do
    splitter = StringSplitter.new 'somelongstring'

    splitter.break_with(['bob']).should eq ['somelongstring']
  end

  it 'should include token and remainder if token at start of string' do
    splitter = StringSplitter.new 'somelongstring'

    splitter.break_with(['somelong']).should eq ['somelong', 'string']
  end

  it 'should include tokens around remainder if tokens at either end of string' do
    splitter = StringSplitter.new 'somelongstring'

    splitter.break_with(['some', 'string']).should eq ['some', 'long', 'string']
  end

  it 'should split up string around tokens including tokens in order' do
    splitter = StringSplitter.new 'somelongstring'

    splitter.break_with(['om', 'ong', 'rin']).should eq ['s', 'om', 'el', 'ong', 'st', 'rin', 'g']
  end

end