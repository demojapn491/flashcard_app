require "../models/card"

class CardPresenter
  protected def initialize(@card : Card)
  end

  def self.present_all(xs, &block)
    xs.each{|x| yield self.new(x)}
  end

  def self.present(x)
    self.new x
  end

  getter(kanji) { KanjiPresenter.new @card.kanji.not_nil! }

  private def id
    @card.id
  end

  delegate onyomi, kunyomi, meanings, jlpt, freq, strokes, grade, words_link, to: kanji
  delegate failures, successes, buried?, to: @card

  def char!
    @card.kanji.not_nil!.char
  end

  def id!
    @card.id.not_nil!
  end

  def kanji_id!
    @card.kanji_id.not_nil!
  end

  def show_link
    "/cards/#{id}"
  end
  def edit_link
    "/cards/#{id}/edit"
  end
  def index_link
    "/cards"
  end

  def id_input_type
    @card.kanji_id ? "hidden" : "text"
  end

  def row_class
    if forgetfulness < 1
      ""
    elsif forgetfulness > 1
      "danger"
    else
      "warning"
    end
  end

  getter(forgetfulness : Float64) { @card.forgetfulness.round(4) }

  def notes
    @card.notes.not_nil!.gsub({'(' => "<strong>", ')' => "</strong>",'[' => "<em>", ']' => "</em>"})
  end

  private def tsv_tags
    [ "jlpt", "grade"].zip([kanji.jlpt?, kanji.grade?])
      .reject{|p| p[1].nil?}
      .map(&.join)
      .join(' ')
  end

  def tsv
    ["<span lang='ja'>#{char!}</span>", [meanings, onyomi, kunyomi, notes].join("<br>"), tsv_tags].join('\t')
  end

end
