require 'nokogiri'

class XmlGenerator
  attr_reader :sitemap_urls

  def initialize(founded_urls, id)
    @founded_urls = founded_urls
    @id = id
    @sitemap_urls = []
  end

  def generate
    number_of_files = count_files_number
    if number_of_files.length == 1
      create_one_file
    else
      create_few_files(number_of_files)
    end
  end

  private
  def count_files_number
    urls_with_code_length = 0
    separators = []
    @founded_urls.each_with_index do |url, index|
      urls_with_code_length += (url.to_s.length + 37)

      if (urls_with_code_length + 110) >= 10000000
        separators.push(index)
        urls_with_code_length -= (urls_with_code_length + 110)
      end
    end

    separators.empty? ? [@founded_urls.length] : separators
  end

  def create_one_file
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.urlset(:xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') do
        @founded_urls.each do |url|
          xml.url {
            xml.loc_ url
          }
        end
      end
    end

    @sitemap_urls.push(save_file("sitemap-xml/#{@id}.xml", builder.to_xml))
  end

  def create_few_files(separators)
    xmls = []
    indexes_array = make_arrays(separators)

    indexes_array.each do |i|
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.urlset(:xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') do
          i.each do |m|
            xml.url {
              xml.loc_ @founded_urls[m]
            }
          end
        end
      end

      xmls.push(builder)
    end

    xmls.each_with_index do |xml, index|
      @sitemap_urls.push(save_file("sitemap-xml/#{@id}-#{index}.xml", xml.to_xml))
    end

    add_storage_file if xmls.length > 1
  end

  def add_storage_file
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.sitemapindex(:xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') do
        @sitemap_urls.each do |m|
          xml.sitemap {
            xml.loc_ @founded_urls[m]
          }
        end
      end
    end

    @sitemap_urls.push(save_file("sitemap-xml/#{@id}.xml", builder.to_xml))
  end

  def make_arrays(sep)
    arr = []
    sep.each_with_index do |s, index|
      if index == 0
        arr.push(@founded_urls[0..s])
      else
        arr.push(@founded_urls[(sep[index-1]+1)..s])
      end
    end
    arr.push(@founded_urls[(sep.last+1)..@founded_urls.length+1])

    arr
  end

  def save_file(name, xml)
    directory = "public/"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(xml) }
    name
  end
end
