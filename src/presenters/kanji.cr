require "../models/kanji"

class KanjiPresenter
  protected def initialize(@kanji : Kanji)
  end

  def self.present_all(xs, &block)
    xs.each_with_index {|x| yield self.new(x)}
  end

  def self.present(x)
    self.new x
  end

  delegate_with onyomi, kunyomi, meanings, to: @kanji, after: join(", ")
  delegate char, id, jlpt?, grade?, freq?, to: @kanji
  #todo: maybe use the ? variants instead here
  delegate_with jlpt, freq, strokes, grade, to: @kanji, after: try{|i| i == UInt32::MAX ? "-" : i.to_s}

  def show_link
    raise "Do not have the id for #{@kanji}" if id < 0
    "/kanji/#{id}"
  end

  def has_card?
    !@kanji.card.nil?
  end

  def card_link : String
    "/cards/#{@kanji.card.try &.id}"
  end

  def new_card_link : String
    raise "Can't have multiple cards for one kanji" if has_card?
    params = HTTP::Params.build { |form| form.add "kanji_id", id.to_s }
    "/cards/new/?#{params}"
  end

  def words_link
    "http://tangorin.com/general/#{char}"
  end


end
