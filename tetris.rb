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

# Game constants
ROW = 16 # x
COLUMN = 10 # y
SQUARE_SIZE = 25
BOARD_OFFSET = 50
COLORS = {1 => "1.png", 2 => "2.png", 3 => "3.png", 4 => "4.png", 5 => "5.png", 6 => "6.png", 7 => "7.png"}

#Global variables
@score = 0
@level = 1
@lines = 0
@objects = []

def create_square(x, y, size, color)
  @objects << Image.new("images/#{COLORS[color]}", x: x, y: y, width: SQUARE_SIZE, height: SQUARE_SIZE)
end

def draw_board(board)

  @objects.each {|s| s.remove}
  @objects = []
  @objects << Text.new(@score, x: 350, y: 65, font: 'early_gameboy.ttf', size: 20, color: '#262626')
  @objects << Text.new(@level, x: 400, y: 155, font: 'early_gameboy.ttf', size: 20, color: '#262626')
  @objects << Text.new(@lines, x: 400, y: 220, font: 'early_gameboy.ttf', size: 20, color: '#262626')

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

def detect_colision(board, piece, begin_column, begin_row, direction=0)
  # loop the tetromino array
  piece.each_with_index do |x, xi|
    x.each_with_index do |y, yi|
      # return a colision with the wall if the conditions below are met
      if 
        y > 0 && ( # the position os a part pof the tetromino and
          yi + begin_column + direction < 0 || # the position is out of bounds to the left or
          yi + begin_column + direction > COLUMN-1 || # the position is out of bounds to the right or 
          xi+begin_row >= ROW || # the position is out of bounds to the bottom or
          board[xi+begin_row][yi+begin_column + direction] > 0 # the board is not empty at that position
          )
        return true
      end
    end
  end

  return false
end

def check_full_lines(board)
  board.each_with_index do |val, index|
    if not board[index].include?(0) then
      board.delete_at(index)
      board.unshift([0,0,0,0,0,0,0,0,0,0])
      @score += 1
      @lines += 1
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
    if !detect_colision(board, piece, begin_column, begin_row, -1)
      begin_column -= 1
    end
  elsif event.key == "right"
    if !detect_colision(board, piece, begin_column, begin_row, +1)
      begin_column += 1
    end
  elsif event.key == "space"
    # rotate the teromino if it does not colide
    rotated_piece = piece.reverse.transpose
    if !detect_colision(board, rotated_piece, begin_column, begin_row) then
      piece = piece.reverse.transpose
    end
  elsif event.key == "down"
    if !detect_colision(board, piece, begin_column, begin_row) then
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

    if !detect_colision(board, piece, begin_column, begin_row) then
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
