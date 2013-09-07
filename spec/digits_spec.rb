require_relative '../lib/egrex'

describe 'digit matching' do

  include Egrex

  describe '1 digit example' do
    it 'should match a digit' do
      eg('1').match('9').ok.should be_true
    end

    it 'should not match a character' do
      eg('2').match('x').ok.should be_false
    end
  end

  describe '2 digit example' do
    it 'should match 2 digits' do
      eg('12').match('67').ok.should be_true
    end

    it 'should not match 1 digit' do
      eg('12').match('6').ok.should be_false
    end
  end

  describe '3 digit example' do
    it 'should match 3 digits' do
      eg('123').match('370').ok.should be_true
    end

    it 'should not match 2 digits' do
      eg('123').match('98').ok.should be_false
    end

    it 'should not match 4 digits' do
      result = eg('123').match('9876')
      result.ok.should be_false
      result.description.should start_with('Whole string not matched')
    end

    it 'should allow zero padding' do
      eg('123').match('007').ok.should be_true
    end
  end

end