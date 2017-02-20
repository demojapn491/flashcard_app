require "../spec_helper"
require "kemalyst-spec"

def some_kanji
  Kanji.all.sample
end

def some_card
  Card.new 0, "notes"
end
