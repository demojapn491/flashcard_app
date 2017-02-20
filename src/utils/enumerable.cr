module Enumerable(T)
  def uniq? : Bool
    s = Set(T).new
    each_with_index do |e,i|
      s.add e
      return false if s.size != i+1
    end
    return true
  end

  def weighted_pick(p, &block : T -> _) : T?
    each do |e|
      w = yield e
      p -= w
      return e if p < 0
    end
    nil
  end
end
