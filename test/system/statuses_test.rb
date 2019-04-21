require "application_system_test_case"

class StatusesTest < ApplicationSystemTestCase
  setup do
    @status = statuses(:one)
    @model_class = Status
  end

  test "visiting the index" do
    visit statuses_url
    assert_selector 'h1', text: @model_class.model_name.human.pluralize(I18n.locale).titleize
  end

  test "creating a Status" do
    visit statuses_url
    click_on I18n.t('helpers.titles.new', model: @model_class.model_name.human)
    assert_selector 'label', text: @model_class.human_attribute_name(:description)
    fill_in @model_class.human_attribute_name(:description), with: @status.description
    click_on I18n.t('helpers.titles.new', model: @model_class.model_name.human)

    assert_text I18n.t('forms.created', model: @model_class.model_name.human)
    
  end

  test "updating a Status" do
    visit statuses_url
    click_on I18n.t('helpers.links.edit'), match: :first

    fill_in @model_class.human_attribute_name(:description), with: @status.description
    click_on I18n.t('helpers.titles.edit', model: @model_class.model_name.human)

    assert_text I18n.t('forms.updated', model: @model_class.model_name.human)
    
  end

  test "destroying a Status" do
    visit statuses_url
    page.accept_confirm do
      click_on I18n.t('helpers.links.destroy'), match: :first
    end

    assert_text I18n.t('forms.deleted', model: @model_class.model_name.human)
  end
end
