require 'pathname'
require 'net/http'
require 'uri'

module UrlCheckable
  def is_url_real?(uri)
    encoded_uri = URI.encode(uri.to_s)
    url = URI.parse(encoded_uri)
    req = Net::HTTP.new(url.host, url.port)
    res = req.request_head(url.path)
    res.code == "200"
  rescue => e
    false
  end

  def normalize_link(rel, url)
    link = URI.parse(compact_link(rel, url))

    unless link.fragment || link.query || link.path == '//' || include_file?(link.path) || !link.to_s.include?(url)
      link
    else
      false
    end
  rescue => e
    Rails.logger.info "Made with exception {exception: #{e}, function: #{__method__}"
    return false
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
