require "../util"
require "./readable_model_mixin"

class Kanji
  extend ReadableModelMixin

  json_and_yaml_mapping(
    char: {
      type: Char,
      converter: StringToChar,
    },
    meanings: Array(String),
    onyomi: Array(String),
    kunyomi: Array(String),
    freq: {
      type: UInt32,
      default: UInt32::MAX,
    },
    jlpt: {
      type: UInt32,
      default: UInt32::MAX,
    },
    strokes: {
      type: UInt32,
      default: UInt32::MAX,
    },
    grade: {
      type: UInt32,
      default: UInt32::MAX,
    },
  )

  getter card : Card?
  getter id = -1

  # Should only be called by Card and Kanji
  def card=(c : Card)
    raise "wrong card for kanji #{char}" if c.kanji_id != id
    @card = c
  end
  protected def id=(i : Int32) : Void
    raise "id for kanji #{id} already set, tried id=#{i}" if id >= 0
    @id = i
  end


  def initialize(@char, @meanings, @onyomi, @kunyomi, @freq, @jlpt, @strokes, @grade)
  end

  @@all : Array(Kanji)?

  def self.all : Array(Kanji)
    @@all ||= fetch_all
  end

  def self.count
    all.size
  end

  def self.find(i : Int32) : Kanji?
    all[i]?
  end

  def self.find(c : Char) : Kanji?
    k = all.bsearch &.char.>=(c)
    if k.nil? || k.char != c
      nil
    else
      k
    end
  end

  private def self.fetch_all : Array(Kanji)
    ks = add_indices Array(Kanji).from_json(File.read kanji_path)
    Card.all.each do |c|
      if id = c.kanji_id
        ks[id].card = c
      end
    end
    ks
  end
  private def self.kanji_path : String
    File.join(__DIR__,  "..", "..", "data", "kanji.json")
  end
  private def self.add_indices(xs)
    xs.each_with_index{|x,i| x.id = i}
    xs
  end

  # todo: maybe have these added as a macro
  def jlpt?
    (j = jlpt) == UInt32::MAX ? nil : j
  end
  def grade?
    (g = grade) == UInt32::MAX ? nil : g
  end
  def freq?
    (f = freq) == UInt32::MAX ? nil : f
  end
end
