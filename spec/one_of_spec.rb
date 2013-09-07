require_relative '../lib/egrex'

describe 'one_of matching' do

  include Egrex

  describe 'an example with char which is one_of chars in string of chars' do
    before :each do
      @example = eg('x', 'x' => one_of('abc'))
    end

    it 'should match a' do
      @example.match('a').ok.should be_true
    end

    it 'should match another char from set' do
      @example.match('c').ok.should be_true
    end

    it 'should not match character not in one_of chars' do
      @example.match('x').ok.should be_false
    end
  end

  describe 'can define one_of chars individually specified' do
    it 'should match a char parameter of one_of' do
      eg('y', 'y' => one_of('a', 'b')).match('b').ok.should be_true
    end
  end

end