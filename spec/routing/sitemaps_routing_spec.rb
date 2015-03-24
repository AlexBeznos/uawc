require "rails_helper"

RSpec.describe SitemapsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/sitemaps").to route_to("sitemaps#index")
    end

    it "routes to #new" do
      expect(:get => "/sitemaps/new").to route_to("sitemaps#new")
    end

    it "routes to #show" do
      expect(:get => "/sitemaps/1").to route_to("sitemaps#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/sitemaps/1/edit").to route_to("sitemaps#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/sitemaps").to route_to("sitemaps#create")
    end

    it "routes to #update" do
      expect(:put => "/sitemaps/1").to route_to("sitemaps#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/sitemaps/1").to route_to("sitemaps#destroy", :id => "1")
    end

  end
end
