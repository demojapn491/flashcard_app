form action="/quiz/submit" method="post"
  == csrf_tag(context)
  input type="hidden" name="number_of_questions" value=questions.size
  - questions.each_with_index do |q, i|
    div.question.form-group
      legend.question-text
        - q[:text].split('\n').each do |line|
          div.quest-text-line == line
        input type="hidden" name="c#{i}" value=q[:card_id]
      - q[:choices].each_with_index do |c, j|
        - first_element = i == j && i == 0
        div.question-choice
          input.form-check-input type="radio" name="q#{i}" value=c[:correct] autofocus=first_element
            label.form-check-label == c[:text]
  button.btn.btn-primary.btn-block type="submit" Submit
