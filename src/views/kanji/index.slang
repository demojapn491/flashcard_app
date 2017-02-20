div.table-responsive
  table.table.table-striped.kanji-table
    thead
      tr
        th
          a.plain-link href="/kanji" 字
        th Meanings
        th Onyomi
        th Kunyomi
        th
          a.plain-link href="/kanji?sort=freq" Freq
        th
          a.plain-link href="/kanji?sort=jlpt" JLPT
        th
          a.plain-link href="/kanji?sort=strokes" Strokes
        th
          a.plain-link href="/kanji?sort=grade" Grade
        th
          a.plain-link href="/kanji?sort=card" Card
    tbody
    - KanjiPresenter.present_all(kanji) do |kanji|
      tr
        td
          a.kanji-link href=kanji.show_link #{kanji.char}
        td.meanings = kanji.meanings
        td.onyomi   = kanji.onyomi
        td.kunyomi  = kanji.kunyomi
        td.freq     = kanji.freq
        td.jlpt     = kanji.jlpt
        td.strokes  = kanji.strokes
        td.grade    = kanji.grade
        td.card_link
          -if kanji.has_card?
            a.btn.btn-info.btn-xs href=kanji.card_link Show
          -else
            a.btn.btn-primary.btn-xs href=kanji.new_card_link Create
