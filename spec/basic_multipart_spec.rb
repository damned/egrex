require_relative '../lib/egrex'

describe 'basic multipart matching' do

  include Egrex

  describe 'digits and literals matching' do

    describe 'a literal and a digit' do
      it 'should match a literal then digit' do
        eg('-1').match('-3').ok.should be_true
      end

      it 'should match a digit then literal' do
        eg('1-').match('4-').ok.should be_true
      end
    end

    describe 'two literals and a digit' do
      it 'should match a dash then digit' do
        eg('--1').match('--3').ok.should be_true
      end

      it 'should not match just literals' do
        eg('--1').match('---').ok.should be_false
      end
    end

    describe 'dashed number' do
      it 'should match a dashed number' do
        eg('123-456-7890').match('783-858-9001').ok.should be_true
      end
    end

    describe 'may-be alternative' do
      context 'a simple example' do
        let(:egrex) { eg('123', '123' => may.be('-123-'))}
        it 'should match the example form' do
          expect(egrex.match('891').ok).to be_true
        end

        it 'should not match something between the alternatives' do

        end

        it 'should match the alternative form' do

        end
      end
    end
  end

end
