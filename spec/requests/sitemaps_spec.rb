require 'rails_helper'

RSpec.describe "Sitemaps", :type => :request do
  describe "GET /sitemaps" do
    it "works! (now write some real specs)" do
      get sitemaps_path
      expect(response.status).to be(200)
    end
  end
end
