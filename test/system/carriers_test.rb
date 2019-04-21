require "application_system_test_case"

class CarriersTest < ApplicationSystemTestCase
  setup do
    @carrier = carriers(:one)
  end

  test "visiting the index" do
    visit carriers_url
    assert_selector "h1", text: Carrier.model_name.human.pluralize(I18n.locale).titleize
  end

  test "creating a Carrier" do
    visit carriers_url
    click_on I18n.t('helpers.titles.new', model: Carrier.model_name.human)

    fill_in Carrier.human_attribute_name(:name), with: @carrier.name
    click_on I18n.t('helpers.titles.new', model: Carrier.model_name.human)
    
    assert_text I18n.t('forms.created', model: Carrier.model_name.human)
  end

  test "creating a Carrier without a name " do
    visit carriers_url
    click_on I18n.t('helpers.titles.new', model: Carrier.model_name.human)

    #fill_in Carrier.human_attribute_name(:name), with: @carrier.name
    click_on I18n.t('helpers.titles.new', model: Carrier.model_name.human)
    assert_text 'Nombre no puede estar en blanco'
    
  end

  test "updating a Carrier" do
    visit carriers_url
    click_on I18n.t('helpers.links.edit'), match: :first

    fill_in Carrier.human_attribute_name(:name), with: @carrier.name
    click_on I18n.t('helpers.titles.edit', model: Carrier.model_name.human)

    assert_text I18n.t('forms.updated', model: Carrier.model_name.human)
  end

  test "destroying a Carrier" do
    visit carriers_url
    page.accept_confirm do
      click_on I18n.t('helpers.links.destroy'), match: :first
    end

    assert_text I18n.t('forms.deleted', model: Carrier.model_name.human)
  end
end
