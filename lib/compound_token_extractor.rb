module Egrex
  class CompoundTokenExtractor

    module HashKeyInKeyFinder
      def each_key_in_a_key
        keys = self.keys
        keys.each do |inner_key|
          (keys - [inner_key]).each do |outer_key|
            if outer_key.include? inner_key
              yield inner_key, outer_key
            end
          end
        end
      end
    end
    def tokenize(example_parts, specs)
      spec_tokens = specs.keys
      sub_tokens = []
      if specs.size > 1
        compounds = {}
        specs.extend HashKeyInKeyFinder
        specs.each_key_in_a_key { |inner_key, outer_key|
          unless specs[outer_key].is_a? Array
            specs[outer_key] = [specs[outer_key]]
          end
          unless specs[outer_key].last.is_a? Hash
            specs[outer_key] << {}
          end
        }
        specs.each_key_in_a_key { |inner_key, outer_key|
          specs[outer_key].last[inner_key] = specs[inner_key]
        }
        specs.each_key_in_a_key { |inner_key|
          specs.delete inner_key
        }
      end
      [example_parts, specs]
    end

  end
end