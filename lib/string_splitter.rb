class StringSplitter
  def initialize(string)
    @string = string
  end

  def break_with(tokens)
    broken = [ @string ]
    tokens.each do |token|
      broken = broken.collect { |part|
        part.partition(token)
      }.flatten
    end
    broken.select { |el| !el.empty?}
  end
end