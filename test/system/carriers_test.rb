require "application_system_test_case"

class CarriersTest < ApplicationSystemTestCase
  setup do
    @carrier = carriers(:one)
  end

  test "visiting the index" do
    visit carriers_url
    assert_selector "h1", text: "Carriers"
  end

  test "creating a Carrier" do
    visit carriers_url
    click_on "New Carrier"

    fill_in "Name", with: @carrier.name
    click_on "Create Carrier"

    assert_text "Carrier was successfully created"
    click_on "Back"
  end

  test "updating a Carrier" do
    visit carriers_url
    click_on "Edit", match: :first

    fill_in "Name", with: @carrier.name
    click_on "Update Carrier"

    assert_text "Carrier was successfully updated"
    click_on "Back"
  end

  test "destroying a Carrier" do
    visit carriers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Carrier was successfully destroyed"
  end
end
