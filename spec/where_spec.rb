require_relative '../lib/where'

describe Where do
  describe '#split' do
    let(:where) { Where.new('abc' => :whatever, 'def' => 'blah') }

    it 'should split string into substrings matching keys' do
       expect(where.split('abcdef')).to eq ['abc', 'def']
    end

    it 'should extract the key and remainder where start matches a key' do
       expect(where.split('abcp')).to eq ['abc', 'p']
    end

    it 'should extract the key where string contains a key' do
       expect(where.split('xabcp')).to eq ['x', 'abc', 'p']
    end

    it 'should split non-key sequences into characters' do
       expect(where.split('xyzabcpq')).to eq ['x', 'y', 'z', 'abc', 'p', 'q']
    end
  end
end