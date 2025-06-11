def aBadMethodName(a = nil)
  if a.nil?
    return false
  end

  if a = 5
    return false
  end

  return true
end
