require "./spec_helper"

describe KanjiController do
  Spec.before_each do
  end

  describe KanjiController::Index do
    it "renders all the kanji" do
      get "/kanji"
      response.body.should contain some_kanji.char
    end
  end

  describe KanjiController::Show do
    it "renders a single kanji" do

      get "/kanji/0"
      response.body.should contain Kanji.find(0).char
    end
  end
end
