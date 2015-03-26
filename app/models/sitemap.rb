class Sitemap < ActiveRecord::Base
  validates :url, :url => true
end
