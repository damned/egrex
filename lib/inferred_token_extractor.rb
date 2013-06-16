class InferredTokenExtractor
  def tokenize(example_parts, specifiers = {})
    parts = [example_parts].flatten
    specs = {}
    parts.each do |part|
      specs[part] = specifiers[part] || infer_specifier(part)
    end

    [ parts , specs ]
  end

  def infer_specifier(part)
    if /[[:digit:]]+/.match part
      :digits
    elsif /[[:alpha:]]+/.match part
      :alphabetic
    else
      :unknown
    end
  end
end