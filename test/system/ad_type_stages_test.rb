require "application_system_test_case"

class AdTypeStagesTest < ApplicationSystemTestCase
  setup do
    @ad_type_stage = ad_type_stages(:one)
  end

  test "visiting the index" do
    visit ad_type_stages_url
    assert_selector "h1", text: "Ad Type Stages"
  end

  test "creating a Ad type stage" do
    visit ad_type_stages_url
    click_on "New Ad Type Stage"

    fill_in "Add type", with: @ad_type_stage.ad_type_id
    check "Create invoice" if @ad_type_stage.create_invoice
    fill_in "Position", with: @ad_type_stage.position
    fill_in "Stage", with: @ad_type_stage.stage_id
    click_on "Create Ad type stage"

    assert_text "Ad type stage was successfully created"
    click_on "Back"
  end

  test "updating a Ad type stage" do
    visit ad_type_stages_url
    click_on "Edit", match: :first

    fill_in "Add type", with: @ad_type_stage.ad_type_id
    check "Create invoice" if @ad_type_stage.create_invoice
    fill_in "Position", with: @ad_type_stage.position
    fill_in "Stage", with: @ad_type_stage.stage_id
    click_on "Update Ad type stage"

    assert_text "Ad type stage was successfully updated"
    click_on "Back"
  end

  test "destroying a Ad type stage" do
    visit ad_type_stages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ad type stage was successfully destroyed"
  end
end
