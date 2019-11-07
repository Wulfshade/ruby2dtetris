require 'ruby2d'

# Tetrominoes
tetrominoes = [
  # Z
  [
    [
      [1,1,0],
      [0,1,1],
      [0,0,0]
    ],
    [
      [0,0,1],
      [0,1,1],
      [0,1,0]
    ],
    [
      [0,0,0],
      [1,1,0],
      [0,1,1]
    ],
    [
      [0,1,0],
      [1,1,0],
      [1,0,0]
    ]
  ],

  # S
  [
    [
      [0,1,1],
      [1,1,0],
      [0,0,0]
    ],
    [
      [0,1,0],
      [0,1,1],
      [0,0,1]
    ],
    [
      [0,0,0],
      [0,1,1],
      [1,1,0]
    ],
    [
      [1,0,0],
      [1,1,0],
      [0,1,0]
    ]
  ],   

  # J
  [
    [
      [0,1,0],
      [0,1,0],
      [1,1,0]
    ],
    [
      [1,0,0],
      [1,1,1],
      [0,0,0]
    ],
    [
      [0,1,1],
      [0,1,0],
      [0,1,0]
    ],
    [
      [0,0,0],
      [1,1,1],
      [0,0,1]
    ]
  ],

  # T
  [
    [
      [0,0,0],
      [1,1,1],
      [0,1,0]
    ],
    [
      [0,1,0],
      [1,1,0],
      [0,1,0]
    ],
    [
      [0,1,0],
      [1,1,1],
      [0,0,0]
    ],
    [
      [0,1,0],
      [0,1,1],
      [0,1,0]
    ]
  ],

  # L
  [
    [
      [0,1,0],
      [0,1,0],
      [0,1,1]
    ],
    [
      [0,0,0],
      [1,1,1],
      [1,0,0]
    ],
    [
      [1,1,0],
      [0,1,0],
      [0,1,0]
    ],
    [
      [0,0,1],
      [1,1,1],
      [0,0,0]
    ]
  ],

  # I
  [
    [
      [0,1,0,0],
      [0,1,0,0],
      [0,1,0,0],
      [0,1,0,0]
    ],
    [
      [0,0,0,0],
      [1,1,1,1],
      [0,0,0,0],
      [0,0,0,0]
    ],
    [
      [0,0,1,0],
      [0,0,1,0],
      [0,0,1,0],
      [0,0,1,0]
    ],
    [
      [0,0,0,0],
      [0,0,0,0],
      [1,1,1,1],
      [0,0,0,0]
    ]
  ],

  # O
  [
    [
      [0,0,0,0],
      [0,1,1,0],
      [0,1,1,0],
      [0,0,0,0]
    ],
    [
      [0,0,0,0],
      [0,1,1,0],
      [0,1,1,0],
      [0,0,0,0]
    ],
    [
      [0,0,0,0],
      [0,1,1,0],
      [0,1,1,0],
      [0,0,0,0]
    ],
    [
      [0,0,0,0],
      [0,1,1,0],
      [0,1,1,0],
      [0,0,0,0]
    ]
  ]
]

ROW = 20 # x
COLUMN = 10 # y

def create_square(x, y, size, color)
  @squares << Square.new(x: x, y: y,size: size, color: color)
end

def draw_board(board)

  @squares.each {|s| s.remove}
  @squares = []

  ROW.times do |i|
    COLUMN.times do |j|
      if board[i][j] != 0
        create_square(j*25, i*25, 25, 'red')
      end
    end
  end
end

def draw_piece(piece, begin_column, begin_row)
  piece.each_with_index do |x, xi|
    x.each_with_index do |y, yi|
      if y != 0
        create_square((yi+begin_column)*25, (xi+begin_row-1)*25, 25, 'red')
      end
    end
  end
end

def detect_colision(board, piece, begin_column, begin_row)
  # loop the tetromino array
  piece.each_with_index do |x, xi|
    x.each_with_index do |y, yi|
      # check if the position is a piece part
      if y == 1
        if xi+begin_row >= ROW
          return 1
        elsif board[xi+begin_row][yi+begin_column] == 1
          return 1
        end
      end
    end

  end

  return 0
end

def hit_walls(board, piece, begin_column, begin_row)
  # loop the tetromino array
  piece.each_with_index do |x, xi|
    x.each_with_index do |y, yi|
      if (y == 1 && (yi+begin_column <= 0 || yi+begin_column >= COLUMN-1))
        return 1
      end
    end
  end

  return 0
end

def fuse_piece_to_board(board, piece, begin_column, begin_row)
  piece.each_with_index do |x, xi|
    x.each_with_index do |y, yi|
      if y == 1
        board[xi+begin_row-1][yi+begin_column] = 1
      end
    end
  end
end

@squares = []

board = Array.new(ROW){Array.new(COLUMN){0}}

set title: "Tetris - Ruby Edition!"
set background: 'white'

# Set the window size
set width: 250, height: 500

piece = tetrominoes[rand(6)][0]
begin_column = COLUMN/2 - piece[0].size/2
begin_row = 0

on :key_down do |event|
  if event.key == 'left'
    if hit_walls(board, piece, begin_column, begin_row) == 0 then
      begin_column -= 1
    end
  elsif event.key == 'right'
    if hit_walls(board, piece, begin_column, begin_row) == 0 then
      begin_column += 1
    end
  elsif event.key == "down"
    if detect_colision(board, piece, begin_column, begin_row) == 0 then
      begin_row += 1
    else
      fuse_piece_to_board(board, piece, begin_column, begin_row)
      piece = tetrominoes[rand(6)][0]
      begin_column = COLUMN/2 - piece[0].size/2
      begin_row = 0
    end
  end
  draw_board(board)
  draw_piece(piece, begin_column, begin_row)
end

tick = 0

update do
  if tick % 60 == 0

    if detect_colision(board, piece, begin_column, begin_row) == 0 then
      begin_row += 1
    else
      fuse_piece_to_board(board, piece, begin_column, begin_row)
      piece = tetrominoes[rand(6)][0]
      begin_column = COLUMN/2 - piece[0].size/2
      begin_row = 0
    end

    draw_board(board)
    draw_piece(piece, begin_column, begin_row)

  end

  tick += 1
end

# Show the window
show
