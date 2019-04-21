require "application_system_test_case"

class CharacteristicsTest < ApplicationSystemTestCase
  setup do
    @characteristic = characteristics(:one)
  end

  test "visiting the index" do
    visit characteristics_url
    assert_selector "h1", text: Characteristic.model_name.human.pluralize(I18n.locale).titleize
  end

  test "creating a Characteristic" do
    visit characteristics_url
    click_on I18n.t('helpers.titles.new_f', model: Characteristic.model_name.human)

    fill_in Characteristic.human_attribute_name(:name), with: @characteristic.name
    click_on I18n.t('helpers.titles.new_f', model: Characteristic.model_name.human)

    assert_text I18n.t('forms.created', model: Characteristic.model_name.human)
    
  end

  test "updating a Characteristic" do
    visit characteristics_url
    click_on I18n.t('helpers.links.edit'), match: :first

    fill_in Characteristic.human_attribute_name(:name), with: @characteristic.name
    click_on I18n.t('helpers.titles.edit', model: Characteristic.model_name.human)

    assert_text I18n.t('forms.updated', model: Characteristic.model_name.human)
    
  end

  test "destroying a Characteristic" do
    visit characteristics_url
    page.accept_confirm do
      click_on I18n.t('helpers.links.destroy'), match: :first
    end

    assert_text I18n.t('forms.deleted', model: Characteristic.model_name.human)
  end
end
