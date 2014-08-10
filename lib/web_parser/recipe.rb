module WebParser
  class Recipe
    attr_reader :type, :value, :normalize_method

    def initialize name, *args
      @name, @type, @value, @normalize_method = name, *args
      @value, @type = @type, @value if args.size == 1
    end

    def apply doc
      case @type
      when :val    then @value
      when :css    then normalize(doc.css(@value))
      when :xpath  then normalize(doc.xpath(@value))
      when :lambda then @value.call(doc)
      else raise "uknown recipe type '#{@type}'!"
      end
    end

    private

    def normalize value
      if @normalize_method.respond_to?(:call)
        @normalize_method.call(value)
      else
        value = value.text.gsub("\u00a0", ' ') # replace nbsp with normal space
        @normalize_method ? value.send(@normalize_method) : value
      end
    end
  end
end

