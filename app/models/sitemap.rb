class Sitemap < ActiveRecord::Base
  include UrlCheckable
  serialize :xml, Array

  before_validation :fix_url
  validates :url, :url => true
  validate :url_reality
  before_create :find_urls
  after_create :generate_xml

  private
  def fix_url
    self.url.delete!(' ');
    encoded_uri = URI.encode(self.url)
    url = URI(encoded_uri)
    self.url = "#{url.scheme}://#{url.host}#{url.path.empty? ? url.path + '/' : url.path}"
    self.url.concat('/') if self.url[self.url.size - 1] != '/'
  end

  def url_reality
    unless is_url_real?(self.url)
      self.errors.add(:url, 'is not functional!')
    end
  end

  def find_urls
    @spider = Spider.new(self.url)
    @spider.turn_on
    Rails.logger.info "spider done, founded urls: #{@spider.founded_urls}"
  end

  def generate_xml
    xml = XmlGenerator.new(@spider.founded_urls, self.id)
    xml.generate
    Rails.logger.info "xml generation done, urls: #{xml.sitemap_urls}"
    self.xml = xml.sitemap_urls
    self.save
  end

end
