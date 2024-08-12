require "application_system_test_case"

class AdTypeFieldsTest < ApplicationSystemTestCase
  setup do
    @ad_type_field = ad_type_fields(:one)
  end

  test "visiting the index" do
    visit ad_type_fields_url
    assert_selector "h1", text: "Ad Type Fields"
  end

  test "creating a Ad type field" do
    visit ad_type_fields_url
    click_on "New Ad Type Field"

    fill_in "Add type", with: @ad_type_field.ad_type_id
    fill_in "Format", with: @ad_type_field.form_field_type
    fill_in "Help text", with: @ad_type_field.help_text
    fill_in "Name", with: @ad_type_field.name
    fill_in "Position", with: @ad_type_field.position
    fill_in "Required", with: @ad_type_field.required
    fill_in "Text after", with: @ad_type_field.text_after
    fill_in "Text before", with: @ad_type_field.text_before
    click_on "Create Ad type field"

    assert_text "Ad type field was successfully created"
    click_on "Back"
  end

  test "updating a Ad type field" do
    visit ad_type_fields_url
    click_on "Edit", match: :first

    fill_in "Add type", with: @ad_type_field.ad_type_id
    fill_in "Format", with: @ad_type_field.form_field_type
    fill_in "Help text", with: @ad_type_field.help_text
    fill_in "Name", with: @ad_type_field.name
    fill_in "Position", with: @ad_type_field.position
    fill_in "Required", with: @ad_type_field.required
    fill_in "Text after", with: @ad_type_field.text_after
    fill_in "Text before", with: @ad_type_field.text_before
    click_on "Update Ad type field"

    assert_text "Ad type field was successfully updated"
    click_on "Back"
  end

  test "destroying a Ad type field" do
    visit ad_type_fields_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ad type field was successfully destroyed"
  end
end
