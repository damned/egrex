RSpec::Matchers.define :contain do |*expected|
  match do |actual|
    expected.all? { |substring|
      actual.include? substring
    }
  end
end