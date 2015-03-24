require 'rails_helper'

RSpec.describe "sitemaps/edit", :type => :view do
  before(:each) do
    @sitemap = assign(:sitemap, Sitemap.create!(
      :url => "MyString",
      :xml => "MyText"
    ))
  end

  it "renders the edit sitemap form" do
    render

    assert_select "form[action=?][method=?]", sitemap_path(@sitemap), "post" do

      assert_select "input#sitemap_url[name=?]", "sitemap[url]"

      assert_select "textarea#sitemap_xml[name=?]", "sitemap[xml]"
    end
  end
end
