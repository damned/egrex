require_relative '../../lib/egrex_old'

include EgrexOld

describe 'examples of interesting, useful or complex regexes from the internet' do
  describe 'http://blog.flimflan.com/ReadableRegularExpressions.html' do

    describe 'US social security number parsing' do

      shared_examples :us_ssn_matcher do |matcher|
        it 'should match all numbers' do
          matcher.match('123456789').should_not be_nil
        end
        it 'should match with hyphens in there' do
          matcher.match('123-45-6789').should_not be_nil
        end
        it 'should not match with hyphens in wrong places' do
          matcher.match('123-456-789').should be_nil
        end
      end

      describe 'regex form' do
        include_examples :us_ssn_matcher,

                         /^\d{3}-?\d{2}-?\d{4}$/

      end

      describe 'egrex form' do
        include_examples :us_ssn_matcher,

                         eg('123-45-6789', '-' => :optional)

      end

    end
  end
end
