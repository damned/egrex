require_relative '../lib/egrex'

describe 'literal matching' do

  include Egrex

  describe '1 literal example' do
    it 'should match the literal' do
      eg('-').match('-').ok.should be_true
    end

    it 'should not match a character' do
      eg('-').match('x').ok.should be_false
    end
  end

end