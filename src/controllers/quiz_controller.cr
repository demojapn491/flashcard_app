require "../utils/quiz"
require "../utils/enumerable"
require "../utils/array"

module QuizController
  class Get < Kemalyst::Controller
    @n : UInt32 = 4_u32
    @choices : UInt32 = 4_u32
    @type : String = "notes"
    @flip_qa = false
    def parse(context)
      @n = context.params["n"]?.try(&.to_u32?) || 4_u32
      @choices = context.params["choices"]?.try(&.to_u32?) || 4_u32
      @type = context.params["type"]? || "notes"
      @flip_qa = !!context.params["flip_qa"]?
    end

    def call(context)
      parse context

      cards = sample_cards(@n).map{|c| CardPresenter.present c}
      questions = Quiz.multi_choice cards, @choices.not_nil!, @type, @flip_qa

      if questions.nil?
        context.flash["warning"] = "Could not create #{@choices}-choice quiz with #{@n} cards"
        redirect "/"
      else
        render "quiz/get.slang", "main.slang"
      end
    end


    def sample_cards(n : UInt32)
      Card.all.weighted_sample(n, &.forgetfulness)
    end
  end
  class Submit < Kemalyst::Controller
    def call(context)
      # todo: will need to get the card data back to show/update cards
      results = get_results context
      missed = [] of Card

      results.each do |id, right|
        card = Card.find(id).not_nil!
        card.answered right
        card.save
        missed << card if !right
      end

      grade = 100 * missed.size.to_f / results.size

      if missed.empty?
        context.flash["success"] = "You aced it!"
      else
        context.flash["warning"] = "You missed #{missed.map(&.notes).join " and "}"
      end

      redirect "/"
    end

    def get_results(context) : Array(Tuple(Int32, Bool))
      n = context.params["number_of_questions"].try &.to_i32?
      return [] of Tuple(Int32, Bool) if n.nil?
      (0...n).compact_map do |i|
        if card_id = context.params["c#{i}"].try &.to_i32?
          right = !!context.params["q#{i}"]?.try{|s| s == "true"}
          { card_id, right }
        else
          nil
        end
      end
    end
  end
end

