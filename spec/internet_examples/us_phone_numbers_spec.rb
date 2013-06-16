require_relative '../../lib/egrex_old'

include EgrexOld

describe 'examples of interesting or complex regexes from the internet' do
  describe 'http://net.tutsplus.com/tutorials/php/advanced-regular-expression-tips-and-techniques/' do

    describe 'US phone number parsing' do

      shared_examples :us_phone_number_matcher do |matcher|
      end

      shared_examples :us_phone_number_matcher_not_yet_in_egrex do |matcher|
        it 'should match space delimited' do
          matcher.match('123 555 6789').should_not be_nil
        end

        it 'should match hyphen delimited with 1 prefix and area code in parenthesis' do
          matcher.match('1-(123)-555-6789').should_not be_nil
        end

        xit 'should not match unmatched parenthesis' do # because had to take out (?(2)\)) - replaced with (\))? - since didn't compile for ruby from php example :-/ regex, eh?
          matcher.match('(123-555-6789').should be_nil
        end

        it 'should match dot delimited with area code in parenthesis' do
          matcher.match('(123).555.6789').should_not be_nil
        end

        it 'should not match with missing digit' do
          matcher.match('123 55 6789').should be_nil
        end
      end

      describe 'regex form' do

        regex = /^(1[-\s.])?(\()?\d{3}(\))?[-\s.]?\d{3}[-\s.]?\d{4}$/

        include_examples :us_phone_number_matcher, regex
        include_examples :us_phone_number_matcher_not_yet_in_egrex, regex
      end

      describe 'egrex form' do

        egrex = eg('1-234-567-8900', 
                     '-' => one_of(' -.'), 
                     '1-' => optional, 
                     '234' => may.be('(234)')
                ).show

        include_examples :us_phone_number_matcher, egrex
      end

    end

  end
end
