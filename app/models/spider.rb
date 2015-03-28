require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

class Spider
  include UrlCheckable

  attr_reader :founded_urls

  def initialize(home_page)
    @home_page = home_page
    @links = []
    @founded_urls = []
    @founded_urls.push(home_page)
  end

  def turn_on
    @links[1] = get_links(@home_page)
    self.crawl
  end

  def crawl(depth = 1)
    unless depth == ENV['G_DEPTH'].to_i
      @links[depth].each do |link|
        found_links = get_links(link)

        if found_links
          @founded_urls.push(link)
          @links[depth + 1] = [] if @links[depth + 1].nil?
          @links[depth + 1].concat(found_links.uniq)
        end
      end

      if @links[depth + 1]
        @links[depth + 1].uniq!
        self.crawl(depth + 1)
      end
    else
      add_last_level
    end
  end


  private
  def get_links(url)
    links = []
    page = Nokogiri::HTML(open(url, :allow_redirections => :safe))

    page.css('a').each do |link|
      if link['href']
        normalized_link = normalize_link(link['href'], @home_page)
        links.push(normalized_link) if normalized_link
      end
    end

    links.uniq
  rescue => e
    Rails.logger.info "Made with exception {exception: #{e}, function: #{__method__}"
    return false
  end

  def add_last_level
    @links.last.each do |link|
     @founded_urls.push(link) if is_url_real?(link)
    end

    @founded_urls.uniq!
  end
end
