div.alert class="alert-#{completion_class}" Complete all cards on
  span#complete_on = complete_on.to_s("%F")
div.alert.alert-info.progress_ratio_key #{total_cards} or #{progress_ratio} of kanji have cards

ul.flex-container
  - odd = true
  - CardPresenter.present_all(new_cards) do |card|
    li.card_item 
      - clazz = odd ? "panel-info" : "panel-default"
      - odd = !odd
      .panel class=clazz
        .panel-body
          a.kanji_link href=card.show_link #{card.char!}
