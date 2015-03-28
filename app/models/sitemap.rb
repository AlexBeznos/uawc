require 'uri'
require 'nokogiri'
require 'net/http'
require 'pathname'
require 'open-uri'
require 'open_uri_redirections'

class Sitemap < ActiveRecord::Base
  attr_accessor :links, :checked_links

  before_validation :fix_url
  validates :url, :url => true
  validate :url_reality
  after_validation :set_links_default
  before_create :crawle

  def set_links_default
    self.links = []
    self.checked_links = []
  end

  def crawle(depth = 0)
    if depth == 0
      self.links[1] = get_links(self.url)
      puts self.links[1]
      self.crawle(depth + 1)
    else
      puts '+++++++++'
      puts "depth #{depth}"
      unless depth == ENV['G_DEPTH'].to_i
        self.links[depth].each do |link|
          found_links = get_links(link)

          if found_links
            self.checked_links.push(link)
            self.links[depth + 1] = [] if self.links[depth + 1].nil?
            self.links[depth + 1].concat(found_links.uniq)
          end
        end
        self.links[depth + 1].uniq!
        puts self.links[depth + 1]

        self.crawle(depth + 1)
      else
        self.links[depth].each do |link|
          self.checked_links.push(link) if is_url_real?(link)
        end

        self.checked_links.uniq!
        puts self.checked_links
      end
    end
  end

  def get_links(url)
    puts 'get links'
    links = []

    begin
      page = Nokogiri::HTML(open(url, :allow_redirections => :safe))
    rescue => e
      puts e
      return false
    end

    page.css('a').each do |link|
      if link['href']
        normilized_link = normalize_link(link['href'], self.url)
        links.push(normilized_link) if normilized_link
      end
    end

    links.uniq
  end

  def is_url_real?(uri)
    encoded_uri = URI.encode(uri.to_s)
    url = URI.parse(encoded_uri)
    req = Net::HTTP.new(url.host, url.port)
    res = req.request_head(url.path)
    res.code == "200"
  end

  def fix_url
    url = self.url
    url.concat('/') if url[url.size - 1] != '/'
  end

  private
  def url_reality
    unless is_url_real?(self.url)
      self.errors.add(:url, 'is not functional!')
    end
  end

  def normalize_link(rel, url)
    begin
      link = URI.parse(compact_link(rel, url))
    rescue => e
      puts e
      return false
    end

    unless link.fragment || link.query || link.path == '//' || include_file?(link.path) || !link.to_s.include?(url)
      link
    else
      false
    end
  end

  def include_file?(path)
    pn = Pathname.new(path)
    ext = pn.extname
    if ext =~ /(html)|(php)/
      false
    else
      !ext.empty?
    end
  end

  def compact_link(rel, url)
    return rel if rel.match /^[\w]*:\/\//
    uri = URI(url)
    if rel[0] == '/'
      "#{uri.scheme}://#{uri.host}#{rel}"
    else
      path = uri.path.split('/')[0..-2].select{|m| !m.empty?}.join('/')
      "#{uri.scheme}://#{uri.host}#{path.length == 0 ? path : '/' + path}/#{rel}"
    end
  end
end
