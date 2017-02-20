require "kemalyst-model/adapter/pg"
require "kemalyst-validators"
require "./card_mixin"
require "./kanji"
require "../utils/pg"
require "../utils/kemalyst-model"

require "pg"

class Card < Kemalyst::Model
  adapter pg
  include CardMixin(Kanji)

  include Kemalyst::Validators

  validate :kanji_id, "has kanji id", ->(this : Card) { !this.kanji_id.nil?  }
  validate :kanji_id, "is valid", ->(this : Card) {
    this.kanji_id.try{|i| i < Kanji.all.size} || false
  }
  validate :successes, "successes should not be nil", ->(this : Card) { !this.successes.nil? }
  validate :failures, "failures should not be nil", ->(this : Card) { !this.failures.nil? }

  getter(kanji) { @kanji_id.try{|i| Kanji.all[i]} }

  # id, created_at and updated_at columns are automatically created for you.
  sql_mapping({
  kanji_id: Int32,
  notes: String,
  buried_until: Time,
  failures: Int64,
  successes: Int64,
  })
  JSON.mapping(
    id: Int64?,
    kanji_id: Int32?,
    notes: String?,
    created_at: Time?,
    buried_until: Time?,
    failures: Int64?,
    successes: Int64?,
  )

  @successes = 0_i64
  @failures = 0_i64

  def save
    success = super
    if success
      kanji.not_nil!.card = self
    end
    success
  end

  def self.find_kanji(id : Int32)
    Card.find_by :kanji_id, id
  end

  def initialize
  end

  def initialize(kanji : String, @notes)
    if id = kanji.to_i?
      @kanji_id = id
    elsif kanji.size == 1
      char = kanji[0]
      @kanji_id = Kanji.find(char).try &.id
    end
  end

  def initialize(@kanji_id, @notes)
    @buried_until = Time.now
  end

  def self.since(since_str : String?)
    if since_str
      self.since Time.parse(since_str, "%Y-%m-%d")
    else
      Card.all
    end
  end

  def self.since(time : Time)
    Card.all.select &.created_at.try(&.>(time)) 
  end

  def self.count_since(since)
    if since
      time = Time.parse(since, "%Y-%m-%d")
      # TODO figure out what format needed, "YYYY-MM-DD" did not work
      # Card.all(%Q(WHERE created_at > ?), [since])
      Card.all.count &.created_at.try(&.>(time)) 
    else
      Card.count
    end
  end

  def self.earliest : Time
    @@earliest ||= get_aggregate_time "min", "created_at"
  end
  def self.latest : Time
    get_aggregate_time "max", "created_at"
  end

  @@earliest : Time?
  private def self.get_aggregate_time(function, field) : Time
    stmt = @@adapter.aggregate_statement(@@table_name, function, field)
    scalar(stmt) do |any|
      return any.as(Time)
    end
    raise "Did not return anything in call to aggregate"
  end

end
