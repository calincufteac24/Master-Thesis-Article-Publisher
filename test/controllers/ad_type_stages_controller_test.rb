require "test_helper"

class AdTypeStagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ad_type_stage = ad_type_stages(:one)
  end

  test "should get index" do
    get ad_type_stages_url
    assert_response :success
  end

  test "should get new" do
    get new_ad_type_stage_url
    assert_response :success
  end

  test "should create ad_type_stage" do
    assert_difference('AdTypeStage.count') do
      post ad_type_stages_url, params: { ad_type_stage: { ad_type_id: @ad_type_stage.ad_type_id, create_invoice: @ad_type_stage.create_invoice, position: @ad_type_stage.position, stage_id: @ad_type_stage.stage_id } }
    end

    assert_redirected_to ad_type_stage_url(AdTypeStage.last)
  end

  test "should show ad_type_stage" do
    get ad_type_stage_url(@ad_type_stage)
    assert_response :success
  end

  test "should get edit" do
    get edit_ad_type_stage_url(@ad_type_stage)
    assert_response :success
  end

  test "should update ad_type_stage" do
    patch ad_type_stage_url(@ad_type_stage), params: { ad_type_stage: { ad_type_id: @ad_type_stage.ad_type_id, create_invoice: @ad_type_stage.create_invoice, position: @ad_type_stage.position, stage_id: @ad_type_stage.stage_id } }
    assert_redirected_to ad_type_stage_url(@ad_type_stage)
  end

  test "should destroy ad_type_stage" do
    assert_difference('AdTypeStage.count', -1) do
      delete ad_type_stage_url(@ad_type_stage)
    end

    assert_redirected_to ad_type_stages_url
  end
end
