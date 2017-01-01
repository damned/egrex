describe ExamplePart do
  describe 'with may-be alternative specifier' do
    it 'should ' do
      alternative = May.new.be 'abc'
      alternative.matches? 'abc'
    end
  end
end