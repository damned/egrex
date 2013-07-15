module Egrex
  class CompoundTokenExtractor

    def tokenize(example_parts, specs)
      spec_tokens = specs.keys
      sub_tokens = []
      if spec_tokens.size > 1
        spec_tokens.each do |inner_key|
          spec_tokens.select {|key| key != inner_key}.each do |outer_key|
            if outer_key.include? inner_key
              inner_spec = specs[inner_key]
              outer_spec = specs[outer_key]
              specs[outer_key] = [ outer_spec, {inner_key => inner_spec}]
              sub_tokens << inner_key
            end
          end
        end
      end
      specs.delete_if { |token|
        sub_tokens.include? token
      }
      [example_parts, specs]
    end
  end
end