require 'rspec'
require 'rspec/mocks'
require_relative '../lib/example_tokenizer'


describe ExampleTokenizer do
  describe '#tokenize' do
    before :each do
      @extractors = [double('first extractor'), double('second extractor')]
      @example_tokenizer = ExampleTokenizer.new(*@extractors)
      @specifier = double('Specifier')
      @another_specifier = double('Specifier')
    end

    it 'should delegate example string and where clause specifiers to first tokenizer' do
      specified_tokens = {
          'some' => @specifier,
          'example' => @another_specifier
      }

      @extractors[0].should_receive(:tokenize).
          with(['someexample'], specified_tokens).
          and_return([['some', 'example'], specified_tokens ])
      stub_to_pass_through(@extractors[1])

      tokens, token_specifications = @example_tokenizer.tokenize('someexample', {
          'some' => @specifier,
          'example' => @another_specifier
      })

      tokens.should eq(['some', 'example'])
      token_specifications.should eq(specified_tokens)
    end

    it 'should delegate to tokenizers and pass back tokens and specifiers from final tokenizer' do
      @extractors[0].stub(tokenize: [ ['testcase'], { } ])
      @extractors[1].stub(tokenize: [ ['testcase'], { 'testcase' => :some_specifier } ])

      tokens, token_specifications = @example_tokenizer.tokenize('testcase', {})

      tokens.should eq(['testcase'])
      token_specifications.should eq('testcase' => :some_specifier)
    end

    it 'should convert symbol where specifier names into strings' do
      extractor = double 'extractor'
      stub_to_pass_through(extractor)

      tokenizer = ExampleTokenizer.new(extractor)
      tokens, token_specifications = tokenizer.tokenize('someexample', {
          :some => @specifier,
          :example => @another_specifier
      })
      token_specifications.keys.should eq ['some', 'example']
    end

    it 'should default to no specifiers if not passed' do
      tokens, specs = ExampleTokenizer.new.tokenize('blah')
      tokens.should eq ['blah']
      specs.length.should eq 0
    end
  end
  describe 'ruby 1.9 behaviour being relied upon' do
    describe 'hash' do
      it 'retains string key insertion order' do
        hash = { 'z' => 0, 'e' => 1, 'r' => 2, 'o' => 3, 'x' => 4 }
        hash.keys.should eq [ 'z', 'e', 'r', 'o', 'x' ]
      end
      it 'retains symbol key insertion order' do
        hash = { z: 0, e: 1, r: 2, o: 3, x: 4 }
        hash.keys.should eq [ :z, :e, :r, :o, :x ]
      end
      it 'retains original string key position even if value overwritten' do
        hash = { 'z' => 0, 'e' => 1, 'r' => 2, 'o' => 3, 'x' => 4 }
        hash['z'] = 999
        hash.keys.should eq [ 'z', 'e', 'r', 'o', 'x' ]
      end
    end
  end
end

def stub_to_pass_through(tokenizer)
  tokenizer.stub(:tokenize) do |tokens, specified|
    [tokens, specified]
  end
end

