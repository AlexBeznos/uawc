require 'rails_helper'

RSpec.describe "sitemaps/index", :type => :view do
  before(:each) do
    assign(:sitemaps, [
      Sitemap.create!(
        :url => "Url",
        :xml => "MyText"
      ),
      Sitemap.create!(
        :url => "Url",
        :xml => "MyText"
      )
    ])
  end

  it "renders a list of sitemaps" do
    render
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
