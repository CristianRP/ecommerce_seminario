require "application_system_test_case"

class VillagesTest < ApplicationSystemTestCase
  setup do
    @village = villages(:one)
  end

  test "visiting the index" do
    visit villages_url
    assert_selector "h1", text: "Villages"
  end

  test "creating a Village" do
    visit villages_url
    click_on "New Village"

    fill_in "Cod", with: @village.cod
    fill_in "Department", with: @village.department_id
    fill_in "Municipality", with: @village.municipality_id
    fill_in "Name", with: @village.name
    click_on "Create Village"

    assert_text "Village was successfully created"
    click_on "Back"
  end

  test "updating a Village" do
    visit villages_url
    click_on "Edit", match: :first

    fill_in "Cod", with: @village.cod
    fill_in "Department", with: @village.department_id
    fill_in "Municipality", with: @village.municipality_id
    fill_in "Name", with: @village.name
    click_on "Update Village"

    assert_text "Village was successfully updated"
    click_on "Back"
  end

  test "destroying a Village" do
    visit villages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Village was successfully destroyed"
  end
end
