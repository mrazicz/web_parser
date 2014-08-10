# WebParser [![Code Climate](https://codeclimate.com/github/mrazicz/web_parser/badges/gpa.svg)](https://codeclimate.com/github/mrazicz/web_parser)

Simple gem for easy information fetching from web pages.

## Installation

Add this line to your application's Gemfile:

    gem 'web_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install web_parser

## Example usage

Just write your own class and include WebParser::Doc.

```ruby
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
```

Then just initialize your class and call `parse`.

```ruby
require 'open-uri'

html_page = open('http://search.yahoo.com/search?p=Ruby').read

YahooSearch.new(html_page).parse
=> {:query=>"Ruby",
    :query_downcase=>"ruby",
    :page_number=>1,
    :first_page?=>true,
    :right_links=>{:sign_in=>"Sign In", :mail=>"Mail"},
    :results=>
      [
        {
          :name=>"Ruby Programming Language",
          :url=>"https://www.ruby-lang.org/en/" },
        {
          :name=>"Ruby - Wikipedia, the free encyclopedia",
          :url=>"http://en.wikipedia.org/wiki/Ruby"},
        {
          :name=>"Ruby - Image Results",
          :url=>"http://images.search.yahoo.com/search/images?_adv_prop=image&va=Ruby"},
        {
          :name=>"Ruby (programming language) - Wikipedia, the free
                encyclopedia",
          :url=>"http://en.wikipedia.org/wiki/Ruby_(programming_language)"},
        {
          :name=>"‘Ruby’ Today: Reality Star Dishes on Show’s Failure ...",
          :url=>"http://abcnews.go.com/blogs/entertainment/2013/01/ruby-today-reality-star-dishes-on-shows-failure/"},
        {
          :name=>"Download Ruby",
          :url=>"https://www.ruby-lang.org/en/downloads/"},
        {
          :name=>"Ruby: The gemstone Ruby information and pictures",
          :url=>"http://www.minerals.net/gemstone/ruby_gemstone.aspx"},
        {
          :name=>"Ruby - Gemstone",
          :url=>"http://www.gemstone.org/index.php?option=com_content&view=article&id=85:ruby&catid=1:gem-by-gem&Itemid=14"},
        {
          :name=>"Buy Loose Precious Ruby Gemstones at Wholesale Prices from ...",
          :url=>"http://www.gemselect.com/ruby/ruby.php"},
        {
          :name=>"Ruby on Rails",
          :url=>"http://rubyonrails.org/"},
        {
          :name=>"Ruby (Adventures) - Bulbapedia, the community-driven Pokémon ...",
          :url=>"http://bulbapedia.bulbagarden.net/wiki/Ruby_(Adventures)"}
      ]
    }

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
