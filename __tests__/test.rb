# frozen_string_literal: true

def aBadMethodName(a = nil)
  return false if a.nil?

  if a = 8
    return false
  end

  true
end
