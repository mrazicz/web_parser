require 'open-uri'
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
require 'web_parser'

class YahooSearch
  # include WebParser
  include WebParser::Doc

  # define recipes
  recipes do
    # simplest way to define recipe
    query          :xpath, '//input[@id="yschsp"]/@value'
    # You can use simple normalization as last parameter
    query_downcase :xpath, '//input[@id="yschsp"]/@value',
                   ->(value) { value.text.downcase }
    # You can also provide just method name for normalization
    page_number    :css, '#pg > strong', :to_i
    # Or you can do whatever you want to obtain value, just provide lambda as
    # parameter
    first_page?    :lambda, ->(doc) {
      doc.css('#pg > strong').text.to_i == 1
    }
    # Nesting
    right_links do
      sign_in :css, '#yucs-profile', :strip
      mail    :css, '#yucs-mail_link_id', :strip
    end
    # Array, usefull for example when parsing eshops
    results :css, '#web > ol > li' do
      name :css, '> .res h3'
      url  :xpath, './/h3[1]/a/@href'
    end
  end
end

html_page = open('http://search.yahoo.com/search?p=Ruby').read

rslt = YahooSearch.new(html_page).parse

require 'pp'

pp rslt

