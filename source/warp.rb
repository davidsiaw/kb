# frozen_string_literal: true

require 'active_support/inflector'
require 'color'
require 'cgi'

class ::NilClass
  def expr
    ['inherit']
  end
end

class ::Symbol
  def expr
    [to_s.sub('_', '-')]
  end
end

class Dimensional
  attr_reader :num, :units

  def initialize(num, units)
    @num = num
    @units = units
  end

  def expr
    ["#{num}#{units}"]
  end
end

class ::Numeric
  UNITS = Set.new %i[px em vw deg grad rad turn]

  def method_missing(name, *args, &block)
    return super unless UNITS.include? name

    Dimensional.new(self, name)
  end

  def expr
    [to_s]
  end
end

module Styles
  VARIANTS = [
    '-webkit-',
    '-khtml-',
    '-moz-',
    '-ms-',
    '-o-',
    ''
  ].freeze

  class SidedStyle
    def read_sided_styles(options)
      @top = options[:top] || options[:horizontal] || options[:all]
      @right = options[:right] || options[:vertical] || options[:all]
      @bottom = options[:bottom] || options[:horizontal] || options[:all]
      @left = options[:left] || options[:vertical] || options[:all]
    end

    def sides_defined?
      !sides_undefined?
    end

    def sides_undefined?
      @top.nil? || @right.nil? || @bottom.nil? || @left.nil?
    end

    def sides_expr_list
      "#{@top.expr[0]} #{@right.expr[0]} #{@bottom.expr[0]} #{@left.expr[0]}"
    end
  end

  class PaddingStyle < SidedStyle
    def initialize(options = {})
      read_sided_styles(options)
    end

    def generate
      ["padding: #{sides_expr_list}"]
    end
  end

  class ContentStyle
    def initialize(arg)
      @arg = arg
    end

    def generate
      ["content: '#{@arg}'"]
    end
  end

  class BackgroundStyle
    def initialize(options = {})
      @options = options
    end

    def images
      @options[:image].expr.map do |x|
        "background-image: #{x}"
      end.to_a
    end

    def colors
      @options[:color].expr.map do |x|
        "background: #{x}"
      end.to_a
    end

    def generate
      images + colors
    end
  end

  class BorderStyle < SidedStyle
    def initialize(options = {})
      @options = options
      read_sided_styles(options)
    end

    def radius
      return [] if @options[:radius].nil?

      ["border-radius: #{@options[:radius].expr[0]}"]
    end

    def widths
      return [] if sides_undefined?

      ["border-width: #{sides_expr_list}"]
    end

    def style
      return [] if @options[:style].nil?

      ["border-style: #{@options[:style]}"]
    end

    def particular_radii
      corners = %i[bottom_left bottom_right top_left top_right]
      results = []
      corners.each do |corner|
        key = :"#{corner}_radius"
        next if @options[key].nil?

        results << "border-#{key.to_s.tr('_', '-')}: #{@options[key].expr[0]}"
      end
      results
    end

    def color
      options = @options.map do |k, v|
        [k.to_s.sub(/^color_/, '').to_sym, v] if k.to_s.start_with?('color_')
      end
      options = options.compact.to_h
      options[:all] = @options[:color]

      ss = SidedStyle.new
      ss.read_sided_styles(options)

      return [] if ss.sides_undefined?

      ["border-color: #{ss.sides_expr_list}"]
    end

    def generate
      radius + widths + style + color + particular_radii
    end
  end

  class FontStyle
    def initialize(options = {})
      @options = options
    end

    def family
      return [] if @options[:family].nil?

      ["font-family: #{@options[:family]}"]
    end

    def size
      return [] if @options[:size].nil?

      ["font-size: #{@options[:size].expr[0]}"]
    end

    def generate
      size + family
    end
  end

  class LineStyle
    def initialize(options = {})
      @options = options
    end

    def height
      return [] if @options[:height].nil?

      ["line-height: #{@options[:height].expr[0]}"]
    end

    def generate
      height
    end
  end

  class TextStyle
    def initialize(options = {})
      @options = options
    end

    def indent
      return [] if @options[:indent].nil?

      ["text-indent: #{@options[:indent].expr[0]}"]
    end

    def generate
      indent
    end
  end

  class MarginStyle < SidedStyle
    def initialize(options = {})
      read_sided_styles(options)
    end

    def generate
      ["margin: #{sides_expr_list}"]
    end
  end

  class TransformStyle
    def initialize(*args)
      @args = args
    end

    def generate
      Styles::VARIANTS.map do |variant|
        exprs = @args.map do |arg|
          arg.expr.map do |expr_var|
            expr_var
          end
        end
        "#{variant}transform: #{exprs.join(' ')}"
      end
    end
  end

  class BoxSizingStyle
    def initialize(arg)
      @arg = arg
    end

    def generate
      Styles::VARIANTS.map do |variant|
        @arg.expr.map do |expr_var|
          "#{variant}box-sizing: #{expr_var}"
        end
      end
    end
  end

  class BoxShadowStyle
    def initialize(options = {})
      @options = options

      @options[:inset]&.consume!
      @consumed = false
    end

    def consume!
      @consumed = true
    end

    def inset
      return [] if @options[:inset].nil?

      [
        ', inset',
        *@options[:inset].offsets,
        *@options[:inset].blurs,
        *@options[:inset].color
      ]
    end

    def offsets
      [@options[:x]&.expr || '0', @options[:y]&.expr || '0']
    end

    def blurs
      result = []
      result << @options[:blur].expr if @options[:blur]
      result << @options[:spread].expr if @options[:spread]
      result
    end

    def color
      [@options[:color]&.expr || '#000']
    end

    def arguments
      [*offsets, *blurs, *color, *inset]
    end

    def generate
      return [] if @consumed

      ["box-shadow: #{arguments.join(' ')}"]
    end
  end

  class UserSelectStyle
    def initialize(arg)
      @arg = arg
    end

    def generate
      mobile + desktop
    end

    def desktop
      Styles::VARIANTS.map do |variant|
        "#{variant}user-select: #{@arg.expr[0]}"
      end
    end

    def mobile
      ["-webkit-touch-callout: #{@arg.expr[0]}"]
    end
  end

  class PassthroughStyle
    def initialize(name, arg)
      @name = name.to_s.sub('_', '-')
      @arg = arg
    end

    def generate
      ["#{@name}: #{@arg.expr[0]}"]
    end
  end
end

class LinearGradientExpression
  def initialize(*args)
    @args = args
  end

  def colors
    exprs = []
    @args[1..-1].each do |arg|
      if arg.is_a? ColorExpression
        exprs << arg.expr[0]
      else
        exprs[-1] = exprs[-1] + ' ' + arg.expr[0]
      end
    end
    exprs.join(', ')
  end

  def expr
    Styles::VARIANTS.map do |variant|
      "#{variant}linear-gradient(#{@args[0]}, #{colors})"
    end
  end
end

class ColorExpression
  def initialize(color, alpha = 1)
    @color = color
    @alpha = alpha
  end

  def expr
    return ["##{@color.hex}"] if @alpha == 1

    [@color.css_rgba(@alpha)]
  end
end

class TransformExpression
  def initialize(transform_type, amount)
    @transform_type = transform_type
    @amount = amount
  end

  def expr
    ["#{@transform_type}(#{@amount.expr[0]})"]
  end
end

class StyleGroup
  PASSTHROUGH_STYLES = Set.new %i[
    width
    height
    overflow
    float
    position
    top
    left
    right
    bottom
    color
    vertical_align
  ].freeze

  def initialize(&block)
    @entries = []
    instance_eval(&block)
  end

  def method_missing(name, *args, &block)
    if PASSTHROUGH_STYLES.include? name
      return @entries << passthrough(name, args[0])
    end

    key = "#{name.to_s.camelize}Style"
    return super unless Styles.const_defined?(key)

    cls = Styles.const_get(key)
    obj = cls.new(*args, &block)
    @entries << obj
    obj
  end

  def display(arg)
    @entries << passthrough(:display, arg)
  end

  def passthrough(name, arg)
    Styles::PassthroughStyle.new(name, arg)
  end

  def linear_gradient(*args)
    LinearGradientExpression.new(*args)
  end

  def rgb(hex)
    ColorExpression.new(Color::RGB.by_css(hex))
  end

  def rgba(red, green, blue, alpha)
    ColorExpression.new(Color::RGB.from_fraction(red, green, blue),
                        alpha)
  end

  def rotate(amount)
    TransformExpression.new(:rotate, amount)
  end

  def rotate_x(amount)
    TransformExpression.new(:rotateX, amount)
  end

  def rotate_y(amount)
    TransformExpression.new(:rotateY, amount)
  end

  def rotate_z(amount)
    TransformExpression.new(:rotateZ, amount)
  end

  def translate_y(amount)
    TransformExpression.new(:translateY, amount)
  end

  def scale(amount)
    TransformExpression.new(:scale, amount)
  end

  def generate
    @entries.flat_map(&:generate)
  end
end

class Warp
  def initialize(&block)
    @style_to_element_map = {}
    @imports = []
    instance_eval(&block)
  end

  def import_font(font)
    @imports << "url(https://fonts.googleapis.com/css?family=#{CGI.escape font})"
  end

  def style_for(*args, &block)
    style = StyleGroup.new(&block)
    elements = style.generate.flatten
    elements.each do |elem|
      @style_to_element_map[elem] ||= Set.new
      @style_to_element_map[elem] += args
    end
  end

  def generate
    (imports + style_lines).join("\n")
  end

  def style_lines
    refactored_styles.map do |_c, k, v|
      <<~OUTPUT
        #{k}
        {
          #{v.to_a.sort.join(";\n" + ' ' * 2)};
        }
      OUTPUT
    end
  end

  def imports
    @imports.map { |x| "@import #{x};" }
  end

  def combined_styles
    elements = {}
    @style_to_element_map.each do |line, selector_set|
      keylist = selector_set.to_a.join(', ')
      elements[keylist] ||= Set.new
      elements[keylist] << line
    end
    elements
  end

  def refactored_styles
    combined = combined_styles.map do |k, v|
      [k.split(' ').count, k, v]
    end
    combined.sort_by { |x| -x[0] }
  end
end
