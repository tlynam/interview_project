require 'rails_helper'

RSpec.describe "Get population by year", type: :system do
  before do
    visit populations_path
  end

  it "User is presented with an input form" do
    assert_selector "input[name=year]"
    assert_selector "button[type=submit]"
  end

  describe "When user enters a valid year" do
    it "redirects to a results page" do
      fill_in("year", with: 1950)
      click_button("Submit")
      expect(current_path).to eq "/populations/by_year"
    end

    it "shows a population figure" do
      population = 1950

      fill_in("year", with: population)
      click_button("Submit")

      assert_text("You requested the population for: #{population}")
      assert_text("Population: 151325798")
    end
  end
end
