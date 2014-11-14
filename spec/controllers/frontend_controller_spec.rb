require 'spec_helper'

describe FrontendController do
  render_views

  describe "GET #index" do
    it "should be successful" do
      get :index
      expect(response).to be_success
    end
  end
end