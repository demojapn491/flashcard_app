module ProgressController
  class Index < Kemalyst::Controller
    def call(context)
      total_cards = Card.count
      progress_ratio = (total_cards.to_f / Kanji.count).round(3)
      complete_on = Index.date_to_complete
      completion_class = complete_on > COMPLETE_BY ? "warning" : "success"
      new_cards = Card.since 1.week.ago

      render "progress/index.slang", "main.slang"
    end

    def self.card_ratio
      Card.count.to_f / Kanji.count
    end

    def self.date_to_complete
      span = Card.latest - Card.earliest
      Card.earliest + span / card_ratio
    end

    private COMPLETE_BY = Time.new(2017, 5, 10)

  end
end
