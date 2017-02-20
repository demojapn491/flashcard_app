# todo: does not actually suport "migration", just initialization
require "pg"

module Migration
  extend self

  def connection_url
    ENV["DATABASE_URL"]
  end

  def open_connection
    DB.open connection_url
  end

  def up
    db = open_connection

    db.exec <<-SQL
      CREATE TABLE IF NOT EXISTS cards (
        id bigserial PRIMARY KEY,
        kanji_id integer,
        notes text,
        created_at timestamp default current_timestamp,
        updated_at timestamp default current_timestamp,
        buried_until timestamp default current_timestamp,
        failures bigint default 0,
        successes bigint default 0
      )
    SQL
  end

end
