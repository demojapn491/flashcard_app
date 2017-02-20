-pres = KanjiPresenter.present kanji
div.kanji.row
  div.char.media-left
    a.kanji-link.scale-big href=pres.words_link target="_blank" #{pres.char}
  div.media-body
    p.meanings = pres.meanings
    p.onyomi   = pres.onyomi
    p.kunyomi  = pres.kunyomi

  div.misc-info
    -if pres.freq?
      span.label.label-success Frequency: #{pres.freq}
    -if pres.jlpt?
      span.label.label-success JLPT N#{pres.jlpt}
    -if pres.grade?
      span.label.label-success Grade #{pres.grade}
  -if pres.has_card?
    a.btn.btn-info.btn-xs href=pres.card_link Show
  -else
    a.btn.btn-primary.btn-xs href=pres.new_card_link Create
  a.btn.btn-default.btn-xs href="/kanji" back
