class Sandpile
  constructor: (@size,@canvas_id)->
    # init our 2d array
    @matrix = new Array @size
    for row, idx in @matrix
      @matrix[idx] = new Array @size

    @canvas = document.getElementById @canvas_id


  drop: (x,y)->
    # don't drop off the table
    return unless 0 <= x <= @size
    return unless 0 <= y <= @size

    @matrix[x][y] = ( @matrix[x][y] || 0 )  + 1
    if @matrix[x][y] == 4
      @matrix[x][y] = 0
      @drop x+1, y
      @drop x-1, y
      @drop x, y+1
      @drop x, y-1

  colours: [
    "#000" # 0
    "#600" # 1
    "#900" # 2
    "#C00" # 3
  ]

  draw: ->

    # init the canvas
    @canvas.width = @size
    @canvas.height = @size

    # get the context
    ctx = @canvas.getContext '2d'

    # draw frame
    for row, x in @matrix
      for val, y in row
        ctx.fillStyle = @colours[ @matrix[x][y] || 0 ]
        ctx.fillRect x, y, 2, 2

  run: (max=100000,from=0,drawEvery=1000)->
    x = y = Math.ceil @size / 2

    drawAt = Math.min from+drawEvery, max

    while from < drawAt
      @drop x, y
      from++

    # run draw in next tick
    window.requestAnimationFrame =>
      @draw()
      # continue?
      unless from >= max
        @run max, drawAt, drawEvery
