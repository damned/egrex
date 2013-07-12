module Matchable
  def match(s)
    /^#{to_regex_s}$/.match(s)
  end
end
