- total_f = 0
div.container-fluid
  form.input-group action="/cards/new" method="get"
    input.form-control name="kanji"
      span.input-group-btn
        button.btn.btn-success type="submit"New
div.table-responsive
  table.table.table-striped
    thead
      tr
        th 漢字
        th Notes
        th Forgetfulness
        th Actions
    tbody
    - CardPresenter.present_all(cards) do |card|
      - kanji = card.kanji
      tr class=card.row_class
        td
          a.kanji-link href=card.show_link #{kanji.char}
        td == card.notes
        td
          - f = card.forgetfulness
          - total_f += f
          = f
        td
          a.btn.btn-success.btn-xs href=card.edit_link edit
    td -
    td -
    td = cards.size == 0 ? "-" : (total_f / cards.size).round(3)
    td

