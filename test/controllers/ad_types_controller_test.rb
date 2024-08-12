require "test_helper"

class AdTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ad_type = ad_types(:one)
  end

  test "should get index" do
    get ad_types_url
    assert_response :success
  end

  test "should get new" do
    get new_ad_type_url
    assert_response :success
  end

  test "should create ad_type" do
    assert_difference('AdType.count') do
      post ad_types_url, params: { ad_type: { about: @ad_type.about, description: @ad_type.description, name: @ad_type.name } }
    end

    assert_redirected_to ad_type_url(AdType.last)
  end

  test "should show ad_type" do
    get ad_type_url(@ad_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_ad_type_url(@ad_type)
    assert_response :success
  end

  test "should update ad_type" do
    patch ad_type_url(@ad_type), params: { ad_type: { about: @ad_type.about, description: @ad_type.description, name: @ad_type.name } }
    assert_redirected_to ad_type_url(@ad_type)
  end

  test "should destroy ad_type" do
    assert_difference('AdType.count', -1) do
      delete ad_type_url(@ad_type)
    end

    assert_redirected_to ad_types_url
  end
end
