require 'ruby2d'

# Tetrominoes
tetrominoes = [
  # Z
  [
    [1,1,0],
    [0,1,1],
    [0,0,0]
  ],

  # S
  [
    [0,2,2],
    [2,2,0],
    [0,0,0]
  ],   

  # J
  [
    [0,3,0],
    [0,3,0],
    [3,3,0]
  ],

  # T
  [
    [0,0,0],
    [4,4,4],
    [0,4,0]
  ],

  # L
  [
    [0,5,0],
    [0,5,0],
    [0,5,5]
  ],

  # I
  [
    [0,6,0,0],
    [0,6,0,0],
    [0,6,0,0],
    [0,6,0,0]
  ],

  # O
  [
    [0,0,0,0],
    [0,7,7,0],
    [0,7,7,0],
    [0,0,0,0]
  ]
]

ROW = 16 # x
COLUMN = 10 # y
SQUARE_SIZE = 25
BOARD_OFFSET = 50
COLORS = {1 => "1.png", 2 => "2.png", 3 => "3.png", 4 => "4.png", 5 => "5.png", 6 => "6.png", 7 => "7.png"}

def create_square(x, y, size, color)
  @squares << Image.new("images/#{COLORS[color]}", x: x, y: y, width: SQUARE_SIZE, height: SQUARE_SIZE)
end

def draw_board(board)

  @squares.each {|s| s.remove}
  @squares = []

  ROW.times do |i|
    COLUMN.times do |j|
      if board[i][j] != 0
        create_square(j*SQUARE_SIZE+BOARD_OFFSET, i*SQUARE_SIZE, SQUARE_SIZE, board[i][j])
      end
    end
  end
end

def draw_piece(piece, begin_column, begin_row)
  piece.each_with_index do |x, xi|
    x.each_with_index do |y, yi|
      if y != 0
        create_square((yi+begin_column)*SQUARE_SIZE+BOARD_OFFSET, (xi+begin_row-1)*SQUARE_SIZE, SQUARE_SIZE, y)
      end
    end
  end
end

def detect_colision(board, piece, begin_column, begin_row)
  # loop the tetromino array
  piece.each_with_index do |x, xi|
    x.each_with_index do |y, yi|
      # check if the position is a piece part
      if y > 0
        if xi+begin_row >= ROW || board[xi+begin_row][yi+begin_column] > 0
          return 1
        end
      end
    end

  end

  return 0
end

def hit_left_wall(board, piece, begin_column, begin_row)
  # loop the tetromino array
  piece.each_with_index do |x, xi|
    x.each_with_index do |y, yi|
      if y > 0 && yi+begin_column <= 0
        return 1
      end
    end
  end

  return 0
end

def hit_right_wall(board, piece, begin_column, begin_row)
  # loop the tetromino array
  piece.each_with_index do |x, xi|
    x.each_with_index do |y, yi|
      if y > 0 && yi+begin_column >= COLUMN-1
        return 1
      end
    end
  end

  return 0
end

def check_full_lines(board)
  board.each_with_index do |val, index|
    if not board[index].include?(0) then
      board.delete_at(index)
      board.unshift([0,0,0,0,0,0,0,0,0,0])
    end
  end
end

def fuse_piece_to_board(board, piece, begin_column, begin_row)
  piece.each_with_index do |x, xi|
    x.each_with_index do |y, yi|
      if y > 0
        board[xi+begin_row-1][yi+begin_column] = y
      end
    end
  end

  check_full_lines(board)
end

@squares = []

board = Array.new(ROW){Array.new(COLUMN){0}}

set title: "Tetris - Ruby Edition!"
set background: 'white'
Image.new("images/board.png", width: 500, height: 400)

# Set the window size
set width: 500, height: 400

piece = tetrominoes[rand(7)]
begin_column = COLUMN/2 - piece[0].size/2
begin_row = 0

on :key_down do |event|
  if event.key == "left"
    if hit_left_wall(board, piece, begin_column, begin_row) == 0 then
      begin_column -= 1
    end
  elsif event.key == "right"
    if hit_right_wall(board, piece, begin_column, begin_row) == 0 then
      begin_column += 1
    end
  elsif event.key == "space"
    # rotate the teromino
    piece = piece.reverse.transpose
  elsif event.key == "down"
    if detect_colision(board, piece, begin_column, begin_row) == 0 then
      begin_row += 1
    else
      fuse_piece_to_board(board, piece, begin_column, begin_row)
      piece = tetrominoes[rand(6)]
      begin_column = COLUMN/2 - piece[0].size/2
      begin_row = 0
    end
  end
  draw_board(board)
  draw_piece(piece, begin_column, begin_row)
end

tick = 0

update do
  if tick % 10 == 0

    if detect_colision(board, piece, begin_column, begin_row) == 0 then
      begin_row += 1
    else
      fuse_piece_to_board(board, piece, begin_column, begin_row)
      piece = tetrominoes[rand(6)]
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
