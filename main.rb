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
    x = @size / 2
    y = @size / 2
    drop x, y
  end

  def drop(x,y)
    return unless x.between? 0, @size
    return unless y.between? 0, @size

    @lattice[x,y] = @lattice[x,y] + 1
    if @lattice[x,  y] == 4
      @lattice[x, y] = 0
      drop x+1, y
      drop x-1, y
      drop x, y+1
      drop x, y-1
    end
  end

  def color stack_size
    case stack_size
    when 0
      "#FFFFFF"
    when 1
      "#9DC5FF"
    when 2
      "#A65FFF"
    when 3
      "#F14B64"
    when 4
      "#FF0000"
    else
      "#FFFFFF"
    end
  end
end

sandpile = Sandpile.new(18, debug)

i = 0
1000.times do
  i += 1
  sandpile.step
end

sandpile.to_s
