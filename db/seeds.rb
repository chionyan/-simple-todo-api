3.times do |num|
  Todo.create!(title: "title_#{num}", text: "text_#{num}")
end
