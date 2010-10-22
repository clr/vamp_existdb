require 'test_helper'

class DelmesControllerTest < ActionController::TestCase
  setup do
    @delme = delmes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:delmes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create delme" do
    assert_difference('Delme.count') do
      post :create, :delme => @delme.attributes
    end

    assert_redirected_to delme_path(assigns(:delme))
  end

  test "should show delme" do
    get :show, :id => @delme.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @delme.to_param
    assert_response :success
  end

  test "should update delme" do
    put :update, :id => @delme.to_param, :delme => @delme.attributes
    assert_redirected_to delme_path(assigns(:delme))
  end

  test "should destroy delme" do
    assert_difference('Delme.count', -1) do
      delete :destroy, :id => @delme.to_param
    end

    assert_redirected_to delmes_path
  end
end
