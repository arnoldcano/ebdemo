require 'test_helper'

class DoodadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doodad = doodads(:one)
  end

  test "should get index" do
    get doodads_url
    assert_response :success
  end

  test "should get new" do
    get new_doodad_url
    assert_response :success
  end

  test "should create doodad" do
    assert_difference('Doodad.count') do
      post doodads_url, params: { doodad: { description: @doodad.description, name: @doodad.name } }
    end

    assert_redirected_to doodad_url(Doodad.last)
  end

  test "should show doodad" do
    get doodad_url(@doodad)
    assert_response :success
  end

  test "should get edit" do
    get edit_doodad_url(@doodad)
    assert_response :success
  end

  test "should update doodad" do
    patch doodad_url(@doodad), params: { doodad: { description: @doodad.description, name: @doodad.name } }
    assert_redirected_to doodad_url(@doodad)
  end

  test "should destroy doodad" do
    assert_difference('Doodad.count', -1) do
      delete doodad_url(@doodad)
    end

    assert_redirected_to doodads_url
  end
end
