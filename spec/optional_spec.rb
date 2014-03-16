require_relative '../lib/egrex'

describe 'optional matching' do

  include Egrex

  describe '1 optional literal dash example' do
    let :example do
      eg('-', '-' => :optional)
    end

    it 'should match the dash' do
      example.match('-').ok.should be_true
    end

    it 'should match no dash' do
      example.match('').ok.should be_true
    end

    it 'should not match a character' do
      example.match('x').ok.should be_false
    end
  end

  describe '2 optional literal dashes example' do
    let :example do
      eg('--', '--' => :optional)
    end

    it 'should match two dashes' do
      example.match('--').ok.should be_true
    end

    it 'should match no dashes' do
      example.match('').ok.should be_true
    end

  end

end