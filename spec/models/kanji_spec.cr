require "./spec_helper"
require "../../src/models/kanji.cr"

describe Kanji do
  Spec.before_each do
  end

  describe "right fields" do
    it "should have char char" do
      some_kanji.char.should be_a(Char)
    end
    it "should have String[] meanings" do
      some_kanji.meanings.should be_a(Array(String))
    end
    it "should have String[] onyomi" do
      some_kanji.onyomi.should be_a(Array(String))
    end
    it "should have String[] kunyomi" do
      some_kanji.kunyomi.should be_a(Array(String))
    end
    it "should have an int jlpt" do
      some_kanji.jlpt.should be_a(UInt32)
    end
    it "should have an int grade" do
      some_kanji.grade.should be_a(UInt32)
    end
    it "should have an int freq" do
      some_kanji.freq.should be_a(UInt32)
    end
  end

end
