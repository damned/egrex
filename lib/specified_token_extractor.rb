class SpecifiedTokenExtractor
  def tokenize(example='', specifiers)
    positions = {}
    specs = specifiers
    specs.keys.each do |name|
      positions[name] = example.index(name)
    end
    names_and_positions = sort_by_values(positions)
    names = []
    next_token_pos = 0
    names_and_positions.each { |name, pos|
      if pos > next_token_pos
        names << example.slice(next_token_pos...pos)
        specs[names.last] = nil
      end
      names << name
      next_token_pos = pos + name.length
    }
    [ names, specs ]
  end

  def sort_by_values(hash)
    Hash[hash.sort_by(&:last)]
  end
end