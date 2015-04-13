require 'Matrix'
require 'rainbow'
require 'pry'
require 'chunky_png'

debug = false

ARGV.each do |v|
  if v == "--debug"
    debug = true
  end
end

class Matrix
  # lol ruby, matrices are immutable?!
  public :"[]=", :set_element, :set_component
end

class Sandpile
  attr_accessor :size, :lattice, :frame, :drop_mark, :debug
  def initialize size, debug
    @debug = debug
    @frame = 0
    @size = size
    @lattice = Matrix.build(@size, @size) { 0 }
  end

  def to_s
    previous_row = 0

    @lattice.each_with_index do |v, row, col|
      if row != previous_row
        print "\n"
      end
      previous_row = row
      if @debug
        print "#{v} "
      else
        print Rainbow("▩ ").color(color(v))
      end
    end
    print "\n"
  end

  def to_img name
    png = ChunkyPNG::Image.new(@size, @size, ChunkyPNG::Color::TRANSPARENT)
    @lattice.each_with_index do |v, row, col|
      png[row, col] = ChunkyPNG::Color.from_hex(color(v))
     end
    png.save("#{name}.png", :interlace => true)
  end

  def step
    drop

    @lattice.each_with_index do |v, row, col|
      if v >= 4
        topple(v, row, col)
      end
    end
  end

  def topple v, row, col
    @lattice[row, col] = 0
    @lattice[row - 1, col] = @lattice[row - 1, col] + 1
    @lattice[row, col + 1] = @lattice[row, col + 1] + 1
    @lattice[row + 1, col] = @lattice[row + 1, col] + 1
    @lattice[row, col - 1] = @lattice[row, col - 1] + 1
  end

  def drop
    @lattice[@size / 2, @size / 2] = @lattice[@size / 2, @size / 2] + 1
  end

  def color stack_size
    case stack_size
    when 0
      "#000000"
    when 1
      "#660000"
    when 2
      "#990000"
    when 3
      "#CC0000"
    when 4
      "#FF0000"
    else
      "#CCFFFF"
    end
  end
end

sandpile = Sandpile.new(501, debug)

i = 0
1000000000.times do
  i += 1
  sandpile.step
  if i.to_f % 10000.0 == 0
    puts "#{i}/#{1000000000} - #{i.to_f / 1000000000 * 100 }"
    sandpile.to_img(i)
  end
end
