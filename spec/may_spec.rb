require_relative '../lib/may'

module Egrex

  describe 'may be' do
    describe 'literals' do
      let(:alternative) { May.new.be '---' }

      it 'should match the literal alternative' do
        expect(alternative.matches? '---').to be_true
      end

      it 'should not match mismatched literal' do
        expect(alternative.matches? '-').to be_false
      end
    end

    describe 'numbers' do
      let(:alternative) { May.new.be '123' }

      it 'should match the integer alternative' do
        expect(alternative.matches? '876').to be_true
      end

      it 'should not match unmatching number' do
        expect(alternative.matches? '12').to be_false
      end
    end
  end

end
