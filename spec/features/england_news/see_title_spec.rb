describe "seeing the title" do

  specify "I can see the title when on englands filter page" do
    visit "/engfilter"
    expect(page).to have_content "Comparison Tool"
  end

  specify "I can see tabs of each commision, so can change to other charity comissions" do
    visit"/engfilter"
    click_link ('England')
    click_link ('Scotland')
    click_link ('Northern Ireland')
    expect(page).to have_content "Northern Ireland"
    expect(page).to have_content "England"
    expect(page).to have_content "Scotland"
  end
end