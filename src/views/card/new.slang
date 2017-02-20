- pres = CardPresenter.present card

- if card.errors
  ul.errors
  - card.errors.each do |error|
    li = error

- if card.kanji_id
  h1
    a.kanji-link href=pres.words_link target="_blank" #{pres.char!}
    - focus_notes = true
- else
  h1 New Card
  - focus_notes = false

form action="/cards" method="post"
  == csrf_tag(context)
  div.form-group
    input.form-control type=pres.id_input_type name="kanji_id" placeholder="Kanji_id" value="#{card.kanji_id}" autofocus=!focus_notes
  div.form-group
    textarea.form-control name="notes" placeholder="Notes"  autofocus=focus_notes = ""
  button.btn.btn-primary.btn-xs type="submit" Submit
  a.btn.btn-default.btn-xs href="/cards" back
