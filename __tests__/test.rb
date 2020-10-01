def aBadMethodName(a = nil)
  if a.nil?
    return false
  end

  if a = 8
    return false
  end

  return true
end
