# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
  $movies_total = movies_table.hashes.length
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert page.body.index(e1) < page.body.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(/,\s*/).each do |rating|
    step "I #{uncheck}check \"ratings[#{rating}]\""
  end
end

Then /^(?:|I )should (not )?see the following movies/ do |notsee, movies_table|
  movies_table.hashes.each do |movie|
    step "I should #{notsee}see \"#{movie[:title]}\""
  end
end

Then /^(?:|I )should see all of the movies/ do
  rows = -1
  offset = 0
  while offset = page.source.index("<tr>", offset) do
    offset += "<tr>".length
    rows += 1
  end
  assert rows.should == $movies_total
end
