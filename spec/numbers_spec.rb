require_relative '../lib/egrex'

describe 'number matching' do

  include Egrex

  it 'should match a number with a digit example' do
    eg('1').match('9').ok.should be_true
  end

  it 'should not match a character with a digit example' do
    eg('2').match('x').ok.should be_false
  end


  it 'should match 2 numbers with a 2-digit example' do
    eg('12').match('67').ok.should be_true
  end

  it 'should not match 1 number with a 2-digit example' do
    eg('12').match('6').ok.should be_false
  end
end