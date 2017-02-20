require "../models/kanji"
require "../presenters/kanji"

module KanjiController
  class Index < Kemalyst::Controller
    getter ascending = true, sort = "", select_by = [] of String

    def parse(context)
      query_order = (context.params["order"]? || context.session["kanji_order"]?).try(&.upcase) 
      query_sort = (context.params["sort"]? || context.session["kanji_sort"]?)

      sel = (context.params["select"]? || "").split(/\s*,\s*/)

      @ascending = query_order != "DESC"
      @sort = query_sort || ""
      @select_by = sel

      order_str = (ascending ? "DESC" : "ASC")

      context.session["kanji_order"] = order_str
      context.session["kanji_sort"] = query_sort if query_sort
    end

    def call(context)
      # todo: no user friendly way to sort/select
      # todo: the requested order is ignored, if this code gets refactored out it could get plugged into a SELECT clause though
      parse context
      kanji = select_kanji
      render "kanji/index.slang", "main.slang"
    end

    def select_kanji
      selected = Kanji.all

      if !((s = select_by).empty?)
        selected = selected.reject do |k|
          s.any? do |criteria|
            case criteria
            when "freq"
              k.freq == UInt32::MAX
            when "jlpt"
              k.jlpt == UInt32::MAX
            when "grade"
              k.grade == UInt32::MAX
            when "card"
              k.card.nil?
            else
              false
            end
          end
        end
      end

      case sort
      when "freq"
        selected.sort_by &.freq
      when "jlpt"
        selected.sort_by &.jlpt
      when "grade"
        selected.sort_by &.grade
      when "strokes"
        selected.sort_by &.strokes
      when "card"
        selected.sort_by &.card.nil?.hash
      else
        selected
      end
    end
  end

  class Show < Kemalyst::Controller
    def call(context)
      id = context.params["id"]
      if kanji = Kanji.find id
        render "kanji/show.slang", "main.slang"
      else
        context.flash["warning"] = "Kanji with ID #{id} Not Found"
        redirect "/kanji"
      end
    end
  end

end
