require "../models/card"
require "../presenters/card"

module CardController
  class Index < Kemalyst::Controller
    def call(context)
      # Grab the time to show cards older than
      since = context.params["since"]?

      cards = Card.since since
      render "card/index.slang", "main.slang"
    end
  end

  class Download < Kemalyst::Controller
    def call(context)
      filename = context.request.path[1..-1]
      download = context.params["download"]?.try(&.==("true")) || false

      if download
        context.response.headers["Content-Disposition"] = "attachment; filename=#{filename}"
      end

      case filename
      when /\.json$/
        json Card.all.to_json
      when /\.tsv$/
        context.response.content_type = "text/plain"
        Card.all.each.map{|c| CardPresenter.present(c).tsv}.join('\n')
      end
    end
  end

  class Show < Kemalyst::Controller
    def call(context)
      id = context.params["id"]
      if card = Card.find id
        render "card/show.slang", "main.slang"
      else
        context.flash["warning"] = "Card with ID #{id} Not Found"
        redirect "/cards"
      end
    end
  end

  class New < Kemalyst::Controller
    def call(context)
      kanji_id = context.params["kanji_id"]?.try(&.to_i?)

      # If we don't have an id, check for a valid kanji param
      if !kanji_id && (kanji_str = context.params["kanji"]?) && !kanji_str.empty?
        kanji = Kanji.find(kanji_str[0])

        if kanji
          if kanji.card
            context.flash["warning"] = "Card for #{kanji.char} already exists"
            redirect "/cards"
          end
          kanji_id = kanji.id
        end
      end

      if kanji_id && (card = Card.find_kanji kanji_id)
        context.flash["warning"] = "Card for #{card.kanji.not_nil!.char} already exists"
        redirect "/cards"
      else
        card = Card.new(kanji_id, "")
        render "card/new.slang", "main.slang"
      end
    end
  end

  class Create < Kemalyst::Controller
    def call(context)
      card = Card.new context.params["kanji_id"], context.params["notes"]

      if card.valid?
        if existing = card.kanji.not_nil!.card
          context.flash["warning"] = "Already have a card for that kanji!"
          redirect "/cards/#{existing.id}/edit"
        elsif card.save
          context.flash["success"] = "Created Card successfully."
          redirect "/cards"
        else
          context.flash["danger"] = "Failed to save card!"
          render "card/new.slang", "main.slang"
        end
      else
        card.kanji_id = nil
        context.flash["danger"] = "Could not create Card!"
        render "card/new.slang", "main.slang"
      end
    end
  end

  class Edit < Kemalyst::Controller
    def call(context)
      id = context.params["id"]
      if card = id.to_i?.try{|i| Card.find i}
        render "card/edit.slang", "main.slang"
      else
        context.flash["warning"] = "Card with ID #{id} Not Found"
        redirect "/cards"
      end
    end
  end

  class Update < Kemalyst::Controller
    def call(context)
      id = context.params["id"]
      if card = id.to_i?.try{|i| Card.find i}
      card.kanji_id = context.params["kanji_id"].to_i
      card.notes = context.params["notes"]

        if card.valid? && card.save
          context.flash["success"] = "Updated Card successfully."
          redirect "/cards"
        else
          context.flash["danger"] = "Could not update Card!"
          render "card/edit.slang", "main.slang"
        end
      else
        context.flash["warning"] = "Card with ID #{id} Not Found"
        redirect "/cards"
      end
    end
  end
end
