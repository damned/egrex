require_relative 'string_splitter'

class Where
  def initialize(specifier_hash = {})
    @hash = specifier_hash
  end
  def [](part_key)
    @hash[part_key.to_s]
  end
  def split(s)
    words = StringSplitter.new(s).break_with @hash.keys
    keys_and_chars = words.collect { |word|
      if @hash.has_key? word
        word
      else
        word.chars.to_a
      end
    }
    keys_and_chars.flatten
  end
end

