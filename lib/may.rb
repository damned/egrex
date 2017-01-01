module Egrex

  class Specifier

  end

  class May < Specifier
    def be(specifier)
      @specifier = specifier
      self
    end
    def matches?(part)
      part == @specifier
    end
  end

end

