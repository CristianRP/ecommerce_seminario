require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  setup do
    @category = categories(:one)
  end

  test "visiting the index" do
    visit categories_url
    assert_selector "h1", text: Category.model_name.human.pluralize(I18n.locale).titleize
  end

  test "creating a Category" do
    visit categories_url
    click_on I18n.t('helpers.titles.new_f', model: Category.model_name.human)

    fill_in Category.human_attribute_name(:name), with: @category.name
    click_on I18n.t('helpers.titles.new_f', model: Category.model_name.human)

    assert_text I18n.t('forms.created', model: Category.model_name.human)
  end

  test "creating a Category without a name" do
    visit categories_url
    click_on I18n.t('helpers.titles.new_f', model: Category.model_name.human)

    #fill_in Category.human_attribute_name(:name), with: @category.name
    click_on I18n.t('helpers.titles.new_f', model: Category.model_name.human)

    assert_text 'Nombre no puede estar en blanco'
  end

  test "updating a Category" do
    visit categories_url
    click_on I18n.t('helpers.links.edit'), match: :first

    fill_in Category.human_attribute_name(:name), with: @category.name
    click_on I18n.t('helpers.titles.edit', model: Category.model_name.human)

    assert_text I18n.t('forms.updated', model: Category.model_name.human)
  end

  test "destroying a Category" do
    visit categories_url
    page.accept_confirm do
      click_on I18n.t('helpers.links.destroy'), match: :first
    end

    assert_text I18n.t('activerecord.errors.messages.foreign_key.violation.has_dependencies')
  end
end
