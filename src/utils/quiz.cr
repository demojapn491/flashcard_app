module Quiz
  extend self

  TYPES = %w(readings onyomi kunyomi all notes meanings random)

  # Generate a quiz with multiple choice answers
  def multi_choice(cards, n, type, flip_qa)
    # If we don't have enough cards to make that many questions, give up
    return nil if cards.size < n

    texts = pick_question_texts cards, type

    cards.map_with_index do |c,i|
      choices = answers(max: cards.size, count: n, ans: i).map do |j|
        # Pick what should show up as answer choices
        text = pick_text flip_qa, cards, texts, j
        { correct: j == i, text: text }
      end

      # Now pick the other as the question text
      text = pick_text !flip_qa, cards, texts, i
      { text: text, choices: choices, card_id: c.id! }
    end
  end

  private def pick_text(flip_qa, cards, texts, i)
    flip_qa ? texts[i] : cards[i].char!.to_s
  end

  private def answers(max, count, ans, random = Random::DEFAULT) : Array(Int32)
    nums = (0...max).to_a.sample(count)

    # Shuffle an ans in if not there already
    unless nums.includes?(ans)
      nums[0] = ans
      nums.shuffle!
    end

    nums
  end

  # pick the question text for all cards, falling back to "all"
  # if any is the same, e.g. in the case of onyomi
  private def pick_question_texts(cards, type) : Array(String)
    if type != "all"
      texts = cards.map{|c| pick_question_text c,type}
      return texts if texts.uniq?
    end
    cards.map{|c| pick_question_text c, "all"}
  end

  private def pick_question_text(c, type) : String
    type = TYPES.sample if type == "random"
    case type
    when "notes"
      c.notes.not_nil!
    when "meanings"
      c.meanings.not_nil!
    when "onyomi"
      c.onyomi.not_nil!
    when "kunyomi"
      c.kunyomi.not_nil!
    when "readings"
      [c.onyomi.not_nil!, c.kunyomi.not_nil!].join('\n')
    else
      [c.meanings, c.kunyomi, c.onyomi, c.notes].map(&.not_nil!).join '\n'
    end
  end


end
