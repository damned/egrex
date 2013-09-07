require_relative '../../lib/egrex'

include Egrex

describe 'examples of interesting, useful or complex regexes from the internet' do
  describe 'http://blog.flimflan.com/ReadableRegularExpressions.html' do

    describe 'US social security number parsing' do

      shared_examples :us_ssn_matcher_not_yet_implemented do |matcher|

        it 'should match nine numbers' do
          matcher.match('224466889')[0].should eq '224466889'
        end

        it 'should not match if not enough digits' do
          matcher.match('12345').should be_nil
        end

        it 'should not match if not enough digits' do
          matcher.match('1234567890').should be_nil
        end
        it 'should not match with hyphens in wrong places' do
          matcher.match('111-222-333').should be_nil
        end

        it 'should not match if any leading non-digits' do
          matcher.match('a123456789').should be_nil
        end

        it 'should not match if any trailing non-digits' do
          matcher.match('123-45-6789XX').should be_nil
        end

        it 'should not match if any trailing non-digits' do
          matcher.match('123-45-6789XX').should be_nil
        end
      end

      shared_examples :us_ssn_matcher do |matcher|
        # todo in progress
        it 'should match with hyphens in there' do
          matcher.match('111-22-4445')[0].should eq '111-22-4445'
        end
      end

      describe 'regex form' do

        regex_form = /^\d{3}-?\d{2}-?\d{4}$/

        include_examples :us_ssn_matcher, regex_form
        include_examples :us_ssn_matcher_not_yet_implemented, regex_form

      end

      describe 'egrex form' do
        include_examples :us_ssn_matcher,

                         eg('123-45-6789', '-' => :optional)

      end

    end
  end
end
