div#quiz_form.container-fluid
  form action="/quiz" method="get"
    == csrf_tag(context)
    div.form-group
      label for="n" Number of questions
      input.form-control name="n" type="number" min="4" max="20" value="4" autofocus=true
    div.form-group
      label for="choices" Number of choices
      input.form-control name="choices" type="number" min="4" max="8" value="4"
    div.form-group
      label for="type" Question types
      select.form-control required=true name="type"
        - Quiz::TYPES.each do |type|
          option value="#{type}" #{type.capitalize}
    div.form-check
      label.form-check-label for="flip_qa"
        input.form-check-input name="flip_qa" type="checkbox" checked=false Use kanji as questions

    datalist#quiz-types
      - Quiz::TYPES.each do |type|
        option value="#{type}"
    button.btn.btn-primary.btn-xs type="submit" Give me a quiz!
