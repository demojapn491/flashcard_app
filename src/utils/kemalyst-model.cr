require "kemalyst-model"

class Kemalyst::Model
  def self.count(clause = "", params = [] of DB::Any)
    stmt = @@adapter.count_statement(@@table_name, clause)
    self.scalar(stmt, params) {|s| return s.as(Int64)}
    raise "Could not compute count"
  end

  def self.scalar(clause, params : Array(DB::Any), &block)
    @@adapter.open { |db| yield db.scalar(clause, params) }
  end
end
