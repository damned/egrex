require_relative '../lib/egrex_old'

include EgrexOld

describe 'basic behaviour of api' do
  describe 'invalid arguments' do

    describe 'invalid where' do

        it 'should raise error for unknown specifier' do
          expect {
            egrex = eg('123-456', '-' => :some_unknown_specifier)
          }
          .to raise_error(StandardError, /some_unknown_specifier/)
        end

    end
  end
end
