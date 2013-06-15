class SpecifiedTokenExtractor
  def tokenize(example='', specifiers)
    position = {}
    specifiers.keys.each do |name|
      position[name] = example.index(name)
    end
    specifier_names = sort_by_values(position).keys
    [ specifier_names, specifiers ]
  end

  def sort_by_values(hash)
    Hash[hash.sort_by(&:last)]
  end
end