require "test_helper"

class AdTypeFieldsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ad_type_field = ad_type_fields(:one)
  end

  test "should get index" do
    get ad_type_fields_url
    assert_response :success
  end

  test "should get new" do
    get new_ad_type_field_url
    assert_response :success
  end

  test "should create ad_type_field" do
    assert_difference('AdTypeField.count') do
      post ad_type_fields_url, params: { ad_type_field: { ad_type_id: @ad_type_field.ad_type_id, format: @ad_type_field.form_field_type, help_text: @ad_type_field.help_text, name: @ad_type_field.name, position: @ad_type_field.position, required: @ad_type_field.required, text_after: @ad_type_field.text_after, text_before: @ad_type_field.text_before } }
    end

    assert_redirected_to ad_type_field_url(AdTypeField.last)
  end

  test "should show ad_type_field" do
    get ad_type_field_url(@ad_type_field)
    assert_response :success
  end

  test "should get edit" do
    get edit_ad_type_field_url(@ad_type_field)
    assert_response :success
  end

  test "should update ad_type_field" do
    patch ad_type_field_url(@ad_type_field), params: { ad_type_field: { ad_type_id: @ad_type_field.ad_type_id, format: @ad_type_field.form_field_type, help_text: @ad_type_field.help_text, name: @ad_type_field.name, position: @ad_type_field.position, required: @ad_type_field.required, text_after: @ad_type_field.text_after, text_before: @ad_type_field.text_before } }
    assert_redirected_to ad_type_field_url(@ad_type_field)
  end

  test "should destroy ad_type_field" do
    assert_difference('AdTypeField.count', -1) do
      delete ad_type_field_url(@ad_type_field)
    end

    assert_redirected_to ad_type_fields_url
  end
end
