# frozen_string_literal: true

def aBadMethodName(a = nil)
  return false if a.nil?

  if a = 5
    return false
  end

  true
end
