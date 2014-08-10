module WebParser
  module Doc
    class XPathsNotSet < StandardError; end

    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods
      def recipes &block
        @recipes = Recipes.new(&block) if block_given?
        @recipes
      end
    end

    # @example
    #   recipes do
    #     id          :css,   '.title > h1'
    #     description :xpath, '.desc > p', ->(value) { value.gsub('-', '') }
    #     price       :xpath, '.price > .vat', :to_f
    #     summary     :lambda, ->(doc) {
    #       doc.css('a#total_downloads').gsub(',', '').to_f
    #     }
    #     additional_info do
    #       vat :css, '.vat', :to_i
    #       fee :css, '.fee', :to_f
    #     end
    #     categories :css, '.categories > .category', :to_s do
    #       name :xpath, './li/a'
    #       url  :xpath, './li/a/@href'
    #       count :lambda, ->(doc) {
    #         doc.xpath('./li/a').text =~ /(\d+)$/ && $1
    #       }
    #     end
    #   end

    # Creates a new page parser
    # @param [String] doc Nokogiri object with page we would parsing
    def initialize doc, parser=Nokogiri::HTML
      @doc = parser.parse(doc)
      raise XPathsNotSet, "no recipes defined!" unless self.class.recipes
    end

    # Main method for parsing document
    # @return [Hash] Parsed informations from page in a hash
    def parse
      get_parsed
    end

    private

    def get_parsed
      self.class.recipes.apply(@doc)
    end
  end

end

