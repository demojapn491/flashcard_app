require "./spec_helper"

describe CardController do
  Spec.before_each do
    Card.clear
  end

  describe CardController::Index do
    it "renders all the cards" do
      card = Card.new 0, "notes"
      card.save

      get "/cards"
      response.body.should contain "notes"
      response.body.should contain card.kanji.not_nil!.char
    end
  end

  describe CardController::Show do
    it "renders a single card" do
      card = Card.new 0, "notes"
      card.save

      #TODO
      pres = CardPresenter.new card

      get pres.show_link
      response.body.should contain "notes"
    end
  end

  describe CardController::New do
    it "render new template" do
      get "/cards/new"
      response.body.should contain "New Card"
      response.body.should contain "Kanji_id"
    end
  end

  # TODO: kgen generated code does not compile do to param passing to post
  # describe CardController::Create do
  #   it "creates a card" do
  #     post "/cards", body: {kanji_id: "testing"}
  #     card = Card.all
  #     card.size.should eq 1
  #   end
  # end

  describe CardController::Edit do
    it "renders edit template" do
      card = Card.new 0, "notes"
      card.save
      
      #TODO
      pres = CardPresenter.new card

      get pres.edit_link
      response.body.should contain "Edit"
      response.body.should contain card.kanji.not_nil!.char
    end
  end

  # TODO
  # describe CardController::Update do
  #   it "updates a card" do
  #     card = Card.new 0, "notes"
  #     card.save

  #     #TODO
  #     pres = CardPresenter.new card

  #     put pres.show_link, body: {notes: "test2"}
  #     card = Card.find(card.id).not_nil!
  #     card.notes.should eq "test2"
  #   end
  # end
end
