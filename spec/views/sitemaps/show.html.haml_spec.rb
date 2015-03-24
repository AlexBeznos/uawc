require 'rails_helper'

RSpec.describe "sitemaps/show", :type => :view do
  before(:each) do
    @sitemap = assign(:sitemap, Sitemap.create!(
      :url => "Url",
      :xml => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/MyText/)
  end
end
