require_relative '../egrex'

include Egrex

describe 'examples of interesting or complex regexes from the internet' do
  describe 'http://blog.flimflan.com/ReadableRegularExpressions.html' do

    describe 'US social security number parsing' do

      describe 'regex form' do
        regex = /^\d{3}-?\d{2}-?\d{4}$/
        it 'should match all numbers' do
          regex.match('123456789').should_not be_nil
        end
        it 'should match with hyphens in there' do
          regex.match('123-45-6789').should_not be_nil
        end
        it 'should not match with hyphens in wrong places' do
          regex.match('123-456-789').should be_nil
        end
      end

      describe 'egrex form' do
        egrex = eg '123-45-6789', '-' => :optional
        it 'should match all numbers' do
          egrex.match('123456789').should_not be_nil
        end
        it 'should match with hyphens in there' do
          egrex.match('123-45-6789').should_not be_nil
        end
        it 'should not match with hyphens in wrong places' do
          egrex.match('123-456-789').should be_nil
        end
      end

    end
  end

  describe 'http://net.tutsplus.com/tutorials/php/advanced-regular-expression-tips-and-techniques/' do

    describe 'US phone number parsing' do

      describe 'regex form' do
        regex = /^(1[-\s.])?(\()?\d{3}(\))?[-\s.]?\d{3}[-\s.]?\d{4}$/

        it 'should match space delimited' do
          regex.match('123 555 6789').should_not be_nil
        end

        it 'should match hyphen delimited with 1 prefix and area code in parenthesis' do
          regex.match('1-(123)-555-6789').should_not be_nil
        end

        xit 'should not match unmatched parenthesis' do # because had to take out (?(2)\)) - replaced with (\))? - since didn't compile for ruby from php example :-/ regex, eh?
          regex.match('(123-555-6789').should be_nil
        end

        it 'should match dot delimited with area code in parenthesis' do
          regex.match('(123).555.6789').should_not be_nil
        end

        it 'should not match with missing digit' do
          regex.match('123 55 6789').should be_nil
        end

      end

      describe 'egrex form' do

        egrex = eg('1-234-567-8900', 
                     '-' => one_of(' -.'), 
                     '1-' => optional, 
                     '234' => may.be('(234)')
                ).show

        xit 'should match space delimited' do
          egrex.match('123 555 6789').should_not be_nil
        end

        xit 'should match hyphen delimited with 1 prefix and area code in parenthesis' do
          egrex.match('1-(123)-555-6789').should_not be_nil
        end

        xit 'should not match unmatched parenthesis' do # because had to take out (?(2)\)) - replaced with (\))? - since didn't compile for ruby from php example :-/ regex, eh?
          egrex.match('(123-555-6789').should be_nil
        end

        xit 'should match dot delimited with area code in parenthesis' do
          egrex.match('(123).555.6789').should_not be_nil
        end

        xit 'should not match with missing digit' do
          egrex.match('123 55 6789').should be_nil
        end

      end

    end

  end
end
