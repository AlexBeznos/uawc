require 'rails_helper'

RSpec.describe "sitemaps/new", :type => :view do
  before(:each) do
    assign(:sitemap, Sitemap.new(
      :url => "MyString",
      :xml => "MyText"
    ))
  end

  it "renders new sitemap form" do
    render

    assert_select "form[action=?][method=?]", sitemaps_path, "post" do

      assert_select "input#sitemap_url[name=?]", "sitemap[url]"

      assert_select "textarea#sitemap_xml[name=?]", "sitemap[xml]"
    end
  end
end
