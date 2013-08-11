require_relative '../lib/egrex'

include Egrex

describe 'basic behaviour of api' do
  describe 'invalid arguments' do

    describe 'invalid where' do

        xit 'should raise error for unknown specifier' do
          expect {
            eg('123-456', '-' => :some_unknown_specifier)
          }
          .to raise_error(StandardError, /some_unknown_specifier/)
        end

    end
  end
end
