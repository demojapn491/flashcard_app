require "./enumerable"

class Array(T)
  def rev_sort_by!(&block : T -> _)
    sorted = map {|e| {e, yield e} }.sort! {|x,y| y[1] <=> x[1]}
    @size.times do |i|
      @buffer[i] = sorted.to_unsafe[i][0]
    end
    self
  end

  private class Weighted(T,W)
    getter t : T, w : W
    def initialize(@t, @w)
    end

    def clear_weight : Void
      @w = 0.0
    end

  end

  def weighted_sample(n, random = Random::DEFAULT, &block : T -> W) forall W
    if n < 0
      raise ArgumentError.new("can't get negative number of weighted samples")
    end

    return shuffle if n > size

    sum = 0
    weighted = map do |t|
      w = yield t
      sum += w
      Weighted(T,W).new t, w
    end

    Array(T).new(n) do |i|
      # Select an element and set its weight to 0
      p = random.rand sum
      e = weighted.weighted_pick(p, &.w).not_nil!
      sum -= e.w
      if sum < 0 # with FP errors
        sum = weighted.sum(0,&.w)
      end

      e.clear_weight

      e.t
    end
  end
end
