module WebParser
  class Recipes
    attr_reader :recipes, :type, :recipe

    def initialize type=:single, recipe=nil, &block
      raise "recipe must be set for type :each" if type == :each && !recipe
      @recipes, @type, @recipe = {}, type, recipe
      instance_eval(&block) if block_given?
    end

    def apply doc
      recipes.inject({}) do |mem, (name, val)|
        if val.is_a?(Recipe)
          mem[name] = apply_recipe(doc, val)
        elsif val.is_a?(Recipes)
          mem[name] = apply_recipes(doc, val)
        end
        mem
      end
    end

    def method_missing name, *args, &block
      if    block_given? && args.size == 0
        @recipes[name] = Recipes.new(&block)
      elsif block_given? && (args.size == 2 || args.size == 3)
        args[2] ||= ->(val) { val } # just return array of elements
        @recipes[name] = Recipes.new(:each, Recipe.new(name, *args), &block)
      elsif !block_given? && (args.size == 2 || args.size == 3)
        @recipes[name] = Recipe.new(name, *args, &block)
      else
        super
      end
    end

    private

    def apply_recipe doc, recipe
      recipe.apply(doc)
    end

    def apply_recipes doc, recipes
      if recipes.type == :each
        recipes.recipe.apply(doc).map {|subdoc| recipes.apply(subdoc) }
      else
        recipes.apply(doc)
      end
    end
  end
end

