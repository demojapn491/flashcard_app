module CardMixin(K)
  property(kanji : K?) { K.all[kanji_id] }

  def buried?
    (buried_until || Time.now) > Time.now
  end

  def answered(right : Bool) : Void
    if right
      raise "successes is nil" if successes.nil?
      v = @successes.not_nil!
      @successes = v + 1
    end
  end

  private def total_attempts
    n = failures.not_nil! + successes.not_nil!
  end

  def forgetfulness
    n = total_attempts

    # Unreviewed cards given double the usual max priorty
    return 100.0 if n == 0 || successes.not_nil! == 0

    time_since = Time.now - updated_at.not_nil!

    # Some arbitrary exponential decay factor based on time since
    decay_factor = 0.999 ** (time_since.total_minutes / Math.sqrt(n))

    newness_factor= 1 - 0.75 ** n 

    # Now apply that to the lower bound on success
    accuracy = newness_factor * decay_factor

    1 - accuracy
  end



end

module CardStaticMixin
  def card_for(char : Char)
    self.all.find {|c| c.char == char}
  end
end
