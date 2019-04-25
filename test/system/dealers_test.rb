require "application_system_test_case"

class DealersTest < ApplicationSystemTestCase
  setup do
    @dealer = dealers(:one)
  end

  test "visiting the index" do
    visit dealers_url
    assert_selector "h1", text: Dealer.model_name.human.pluralize(I18n.locale)
  end

  test "creating a Dealer" do
    visit dealers_url
    click_on I18n.t('helpers.titles.new', model: Dealer.model_name.human)

    fill_in Dealer.human_attribute_name(:address), with: @dealer.address
    fill_in Dealer.human_attribute_name(:comission), with: @dealer.comission
    fill_in Dealer.human_attribute_name(:last_name), with: @dealer.last_name
    fill_in Dealer.human_attribute_name(:name), with: @dealer.name
    fill_in Dealer.human_attribute_name(:phone), with: @dealer.phone
    fill_in Dealer.human_attribute_name(:email), with: @dealer.email
    fill_in Dealer.human_attribute_name(:password), with: @dealer.password
    fill_in Dealer.human_attribute_name(:parent_id), with: @dealer.parent_id
    click_on 'Nuevo Vendedor'

    assert_text I18n.t('forms.created', model: Dealer.model_name.human)
    
  end

  test "updating a Dealer" do
    visit dealers_url
    click_on "Editar", match: :first

    fill_in Dealer.human_attribute_name(:address), with: @dealer.address
    fill_in Dealer.human_attribute_name(:comission), with: @dealer.comission
    fill_in Dealer.human_attribute_name(:last_name), with: @dealer.last_name
    fill_in Dealer.human_attribute_name(:name), with: @dealer.name
    fill_in Dealer.human_attribute_name(:phone), with: @dealer.phone
    click_on "Editar Vendedor"

    assert_text I18n.t('forms.updated', model: Dealer.model_name.human)
    
  end

  test "destroying a Dealer" do
    visit dealers_url
    page.accept_confirm do
      click_on "Eliminar", match: :first
    end

    assert_text I18n.t('forms.deleted', model: Dealer.model_name.human)
  end
end
