require "application_system_test_case"

class CharacteristicsTest < ApplicationSystemTestCase
  setup do
    @characteristic = characteristics(:one)
  end

  test "visiting the index" do
    visit characteristics_url
    assert_selector "h1", text: "Characteristics"
  end

  test "creating a Characteristic" do
    visit characteristics_url
    click_on "New Characteristic"

    fill_in "Name", with: @characteristic.name
    click_on "Create Characteristic"

    assert_text "Characteristic was successfully created"
    click_on "Back"
  end

  test "updating a Characteristic" do
    visit characteristics_url
    click_on "Edit", match: :first

    fill_in "Name", with: @characteristic.name
    click_on "Update Characteristic"

    assert_text "Characteristic was successfully updated"
    click_on "Back"
  end

  test "destroying a Characteristic" do
    visit characteristics_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Characteristic was successfully destroyed"
  end
end
