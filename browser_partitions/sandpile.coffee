class Partition
  constructor: (@x1,@y1,@x2,@y2,@parent)->
    # init our 2d array for this partition
    @matrix = new Array @x2 - @x1 + 1
    for row, idx in @matrix
      @matrix[idx] = new Array @y2 - @y1 + 1

  jobs: 0
  drop: (x,y,done)->
    # calculate local x, y
    lx = x - @x1
    ly = y - @y1

    # console.log "dropping #{x},#{y} (local #{lx},#{ly})"

    @jobs++

    if @x2 >= x >= @x1 && @y2 >= y >= @y1
      # drop to self, maybe topple
      @matrix[lx][ly] = ( @matrix[lx][ly] || 0 )  + 1
      @topple x, y if @matrix[lx][ly] == 4
    else
      # drop to parent if outside bounds
      # Not Our Problem Anymore™
      @parent.drop x, y

    # this drop is over as far as we're concerned
    @jobs--
    done() if @jobs is 0

  topple: (x,y)->
    lx = x - @x1
    ly = y - @y1

    # console.log "Toppling at #{x},#{y} (local #{lx},#{ly})"

    @matrix[lx][ly] = 0
    @drop x+1, y
    @drop x-1, y
    @drop x,   y+1
    @drop x,   y-1



class Sandpile
  num_partitions: 9
  drawEvery: 1000
  step: 0
  jobs: 0

               # num partitions must be a perfect square, i.e. 4, 9, 16, etc
  constructor: (@size, @canvas_id)->
    @pw = @partition_width = Math.floor @size / Math.sqrt @num_partitions

    # init our 2d array of partitions
    @partitions = new Array Math.sqrt @num_partitions
    for row, i in @partitions
      @partitions[i] = new Array Math.sqrt @num_partitions

      # init each partition
      for col, j in @partitions[i]
        # console.log "creating partition #{i*@pw},  #{j*@pw},  #{i*@pw+@pw-1},  #{j*@pw+@pw-1}"
        @partitions[i][j] = new Partition i*@pw,  j*@pw,  i*@pw+@pw-1,  j*@pw+@pw-1,  this

    @canvas = document.getElementById @canvas_id

  drop: (x,y)->
    @jobs++

    # figure out which partition to delegate to
    i = Math.floor x / @partition_width
    j = Math.floor y / @partition_width
    part = @partitions[i][j]

    # call drop on partition at x,y with decr cb
    # console.log "parent dropping #{x},#{y}"
    part.drop x, y, @decr.bind @


  decr: ->
    @jobs--
    if @jobs is 0
      # next frame
      if @step % @drawEvery
        setTimeout =>
          @next()
        , 0
      else
        window.requestAnimationFrame =>
          @draw()
          @next()
      return

  next: ->
    @step++
    # console.log @step

    # default x, y
    x = y = Math.ceil @size / 2

    @drop x, y

  colours: [
    "#000" # 0
    "#009" # 1
    "#900" # 2
    "#090" # 3
  ]

  draw: ->

    # init the canvas
    @canvas.width = @size
    @canvas.height = @size

    # get the context
    ctx = @canvas.getContext '2d'

    # draw frame
    for row, i in @partitions
      for col, j in @partitions[i]
        for lrow, k in @partitions[i][j].matrix
          for val, l in @partitions[i][j].matrix[k]
            ctx.fillStyle = @colours[ val || 0 ]

            # get global x, y
            x = i*@pw+k
            y = j*@pw+l

            ctx.fillRect x, y, 2, 2
