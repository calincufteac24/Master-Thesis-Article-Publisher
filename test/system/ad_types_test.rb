require "application_system_test_case"

class AdTypesTest < ApplicationSystemTestCase
  setup do
    @ad_type = ad_types(:one)
  end

  test "visiting the index" do
    visit ad_types_url
    assert_selector "h1", text: "Ad Types"
  end

  test "creating a Ad type" do
    visit ad_types_url
    click_on "New Ad Type"

    fill_in "About", with: @ad_type.about
    fill_in "Description", with: @ad_type.description
    fill_in "Name", with: @ad_type.name
    click_on "Create Ad type"

    assert_text "Ad type was successfully created"
    click_on "Back"
  end

  test "updating a Ad type" do
    visit ad_types_url
    click_on "Edit", match: :first

    fill_in "About", with: @ad_type.about
    fill_in "Description", with: @ad_type.description
    fill_in "Name", with: @ad_type.name
    click_on "Update Ad type"

    assert_text "Ad type was successfully updated"
    click_on "Back"
  end

  test "destroying a Ad type" do
    visit ad_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ad type was successfully destroyed"
  end
end
