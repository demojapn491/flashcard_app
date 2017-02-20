- pres = CardPresenter.present card
- kanji = pres.kanji

div.card_info
  p.char
          a.kanji-link href=kanji.show_link #{kanji.char}
  p.meanings = kanji.meanings
  p.onyomi = kanji.onyomi
  p.kunyomi = kanji.kunyomi
  p.notes == pres.notes
p
  a.btn.btn-default.btn-xs href=pres.index_link back
  a.btn.btn-success.btn-xs href=pres.edit_link edit
