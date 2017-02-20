- if card.errors
  ul.errors
  - card.errors.each do |error|
    li = error
- pres = CardPresenter.present card
- kanji = pres.kanji
- action = pres.show_link
form action="#{ action }" method="post"
  == csrf_tag(context)
  input type="hidden" name="_method" value="put"
  input.form-control type="hidden" name="kanji_id" placeholder="Kanji_id" value="#{ card.kanji_id }"
  div.form-group
    textarea.form-control name="notes" placeholder="Notes" =  card.notes
  button.btn.btn-primary.btn-xs type="submit" Submit
  a.btn.btn-default.btn-xs href="/cards" back
