require "kemalyst-model"

class Kemalyst::Adapter::Pg
  def aggregate_statement(table_name, function, field)
    statement = String.build do |stmt|
      stmt << "SELECT "
      stmt << "#{function}(#{table_name}.#{field})"
      stmt << " FROM #{table_name}"
    end
    statement
  end

  def count_statement(table_name, clause)
    statement = String.build do |stmt|
      stmt << "SELECT "
      stmt << "COUNT(*) "
      stmt << " FROM #{table_name}"
      stmt << " #{clause}"
    end
    statement
  end

end
