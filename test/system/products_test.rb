require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
    @model_class = Product
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: @model_class.model_name.human.pluralize(I18n.locale).titleize
  end

  test "creating a Product" do
    visit products_url
    click_on I18n.t('helpers.titles.new', model: @model_class.model_name.human)

    check @model_class.human_attribute_name(:active) if @product.active    
    fill_in @model_class.human_attribute_name(:category), with: @product.category_id
    fill_in @model_class.human_attribute_name(:characteristic), with: @product.characteristic_id
    fill_in @model_class.human_attribute_name(:cost), with: @product.cost
    fill_in @model_class.human_attribute_name(:descrition), with: @product.description
    fill_in @model_class.human_attribute_name(:price), with: @product.price
    fill_in @model_class.human_attribute_name(:quantity), with: @product.quantity
    fill_in @model_class.human_attribute_name(:sku), with: @product.sku
    click_on I18n.t('helpers.titles.new', model: @model_class.model_name.human)

    assert_text I18n.t('forms.created', model: Product.model_name.human)
    
  end

  test "updating a Product" do
    visit products_url
    click_on I18n.t('helpers.links.edit'), match: :first

    check @model_class.human_attribute_name(:active) if @product.active    
    fill_in @model_class.human_attribute_name(:category), with: @product.category_id
    fill_in @model_class.human_attribute_name(:characteristic), with: @product.characteristic_id
    fill_in @model_class.human_attribute_name(:cost), with: @product.cost
    fill_in @model_class.human_attribute_name(:descrition), with: @product.description
    fill_in @model_class.human_attribute_name(:price), with: @product.price
    fill_in @model_class.human_attribute_name(:quantity), with: @product.quantity
    fill_in @model_class.human_attribute_name(:sku), with: @product.sku
    click_on I18n.t('helpers.titles.edit', model: @model_class.model_name.human)

    assert_text I18n.t('forms.created', model: Product.model_name.human)
  end

  test "destroying a Product" do
    visit products_url
    page.accept_confirm do
      click_on I18n.t('helpers.links.destroy'), match: :first
    end

    assert_text I18n.t('forms.deleted', model: Product.model_name.human)
  end
end
