require 'ruby2d'
require 'pp'

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
      [0,0,0,0,]
    ],
    [
      [0,0,0,0],
      [0,1,1,0],
      [0,1,1,0],
      [0,0,0,0,]
    ],
    [
      [0,0,0,0],
      [0,1,1,0],
      [0,1,1,0],
      [0,0,0,0,]
    ],
    [
      [0,0,0,0],
      [0,1,1,0],
      [0,1,1,0],
      [0,0,0,0,]
    ]
  ]
]

ROW = 20 # x
COLUMN = 10 # y

def create_board
  board = Array.new()

  ROW.times do |i|
    board[i] = []
    COLUMN.times do 
      board[i].push(0)
    end
  end

  pp board
  
  return board
end

def draw_board(board)
  ROW.times do |i|
    COLUMN.times do |j|
      color = board[i][j] == 0 ? 'white' : 'red'
      Square.new(x: j*25, y: i*25, size: 25, color: color)
      #Square.new(x: j*25, y: (i+4)*25, size: 25, color: ['white', 'black', 'red', 'yellow', 'green', 'blue'].sample)
    end
  end
end

def draw_piece(piece, begin_column, begin_row)
  piece.each_with_index do |x, xi|
    x.each_with_index do |y, yi|
      puts "#{xi}#{yi} - #{y}"
      if y != 0 
        Square.new(x: (yi+begin_column)*25, y: (xi+begin_row)*25, size: 25, color: 'red')
      end
    end
  end
end

def detect_colision(board, piece, begin_column, begin_row)
  puts "DETECT COLISION"
  puts "begin_column #{begin_column}"
  puts "begin_row #{begin_row}"
  piece.each_with_index do |x, xi|
    x.each_with_index do |y, yi|
      puts "[#{xi}][#{yi}] - #{y}"
      if y == 1
        puts "board [#{xi+begin_row}][#{yi+begin_column}] - #{board[xi+begin_row][yi+begin_column]}"
        if board[xi+begin_row][yi+begin_column] == 1
          return 1
        end
      end
    end

  end

  print "\n\n"

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


board = create_board

set title: "Tetris - Ruby Edition!"

# Set the window size
set width: 250, height: 500

# Pre placed square to test piece collision
board[18][4] = 1
board[18][5] = 1
board[19][4] = 1
board[19][5] = 1

piece = tetrominoes[rand(6)][0]
begin_column = COLUMN/2 - piece[0].size/2
begin_row = 0

tick = 0

update do
  if tick % 5 == 0

    draw_board(board)
    if detect_colision(board, piece, begin_column, begin_row) == 0 then
      draw_piece(piece, begin_column, begin_row)
      begin_row += 1
    else
      fuse_piece_to_board(board, piece, begin_column, begin_row)
      piece = tetrominoes[rand(6)][0]
      begin_column = COLUMN/2 - piece[0].size/2
      begin_row = 0
    end

  end

  tick += 1
end

# Show the window
show
