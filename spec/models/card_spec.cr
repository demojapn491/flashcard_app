require "./spec_helper"
require "../../src/models/card.cr"

describe Card do
  Spec.before_each do
  end

  describe "validations" do
    it "needs a kanji id" do
      c = Card.new
      c.notes = "foo"
      c.successes = c.failures = 1_i64
      c.valid?.should be_false
    end
    it "needs a kanji id < # kanji" do
      c = Card.new Kanji.all.size, "foo"
      c.successes = c.failures = 1_i64
      c.valid?.should be_false
    end
    it "needs successes" do
      c = Card.new 0, "foo"
      c.successes = nil
      c.valid?.should be_false
    end
  end

  describe "constructor" do
    it "it should be able to lookup by kanji" do
      c = Card.new "表", "(arawa).su"
      c.kanji.not_nil!.char.should eq '表'
      c.valid?.should be_true
    end
  end

end
