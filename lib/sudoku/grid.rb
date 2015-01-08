require_relative '../sudoku'

class Sudoku::Grid
  attr_accessor :array, :possible

  ALL_ORDS = (0...9).to_a.product((0...9).to_a).freeze

  ROWS = [
    [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 8]],
    [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8]],
    [[2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7], [2, 8]],
    [[3, 0], [3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7], [3, 8]],
    [[4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [4, 7], [4, 8]],
    [[5, 0], [5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [5, 7], [5, 8]],
    [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7], [6, 8]],
    [[7, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7], [7, 8]],
    [[8, 0], [8, 1], [8, 2], [8, 3], [8, 4], [8, 5], [8, 6], [8, 7], [8, 8]],
  ].freeze

  COLS = [
    [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0], [8, 0]],
    [[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1]],
    [[0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2], [8, 2]],
    [[0, 3], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3]],
    [[0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4], [8, 4]],
    [[0, 5], [1, 5], [2, 5], [3, 5], [4, 5], [5, 5], [6, 5], [7, 5], [8, 5]],
    [[0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6], [8, 6]],
    [[0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7], [8, 7]],
    [[0, 8], [1, 8], [2, 8], [3, 8], [4, 8], [5, 8], [6, 8], [7, 8], [8, 8]],
  ].freeze

  GRIDS = [
    [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]],
    [[0, 3], [0, 4], [0, 5], [1, 3], [1, 4], [1, 5], [2, 3], [2, 4], [2, 5]],
    [[0, 6], [0, 7], [0, 8], [1, 6], [1, 7], [1, 8], [2, 6], [2, 7], [2, 8]],
    [[3, 0], [3, 1], [3, 2], [4, 0], [4, 1], [4, 2], [5, 0], [5, 1], [5, 2]],
    [[3, 3], [3, 4], [3, 5], [4, 3], [4, 4], [4, 5], [5, 3], [5, 4], [5, 5]],
    [[3, 6], [3, 7], [3, 8], [4, 6], [4, 7], [4, 8], [5, 6], [5, 7], [5, 8]],
    [[6, 0], [6, 1], [6, 2], [7, 0], [7, 1], [7, 2], [8, 0], [8, 1], [8, 2]],
    [[6, 3], [6, 4], [6, 5], [7, 3], [7, 4], [7, 5], [8, 3], [8, 4], [8, 5]],
    [[6, 6], [6, 7], [6, 8], [7, 6], [7, 7], [7, 8], [8, 6], [8, 7], [8, 8]]
  ].freeze

  ALL_SETS = (ROWS + COLS + GRIDS).freeze

  def self.effected_row ord
    ROWS[ord[0]]
  end

  def self.effected_col ord
    COLS[ord[1]]
  end

  def self.effected_grid ord
    GRIDS[ord[0] / 3 * 3 + ord[1] / 3]
  end

  def self.effected_sets ord
    row  = ROWS[ord[0]]
    col  = COLS[ord[1]]
    grid = GRIDS[(ord[0] / 3 * 3) + (ord[1] / 3)]

    [ row, col, grid ]
  end

  def self.from_flat_array array
    Sudoku::Grid.new.tap do |grid|
      array.each do |ord, value|
        grid[ord] = value
      end
    end
  end

  def initialize options = {}
    defaults = {
    }
    config = defaults.merge(options)

    @array = config[:array] || clear
    init_possible
  end

  def [] ord
    @array[ord[0]][ord[1]]
  end

  def []= ord, value
    @array[ord[0]][ord[1]] = value
  end

  def == other
    self.array == other.array
  end

  def all_empty
    ALL_ORDS.select do |ord|
      @array[ord[0]][ord[1]].nil?
    end
  end

  def all_not_empty
    ALL_ORDS.select do |ord|
      @array[ord[0]][ord[1]]
    end
  end

  def clear 
    self.array = Array.new(9) do
      Array.new(9)
    end
  end

  def complete?
    first_empty.nil?
  end

  def effected_sets ord, &block
    Sudoku::Grid.effected_sets(ord).each do |set|
      set.each do |ord|
        block.call(ord)
      end
    end
  end

  def dup
    array_dup = array.map do |row|
      row.map do |value|
        value
      end
    end

    Sudoku::Grid.new array: array_dup
  end

  def init_possible
    @possible = Hash.new { Hash.new }

    ALL_ORDS.each do |ord|
      effected_sets(ord) do |other|
        possible[ord][@array[other[0]][other[1]]] = true
      end
    end
  end

  def first_empty
    ALL_ORDS.find do |ord|
      @array[ord[0]][ord[1]].nil?
    end 
  end

  def minimum_remaining
    all_empty.max_by do |ord|
      Sudoku::Grid.effected_sets(ord).reject { |o| o.nil? }.count
    end
  end

  def no_dups? set
    count = []

    set.each do |ord|
      value = array[ord[0]][ord[1]]
      unless value.nil?
        return false if count[value]
        count[value] = 1
      end
    end

    true  
  end

  def to_a
    @array
  end

  def to_s
    @array.map do |row|
      row.map do |value|
        value.nil? ? "." : value
      end.join(" ")
    end.join("\n").concat("\n")
  end

  def self.from_s string
    array = string.split("\n").map do |row|
      row.split("\s")
    end

    Sudoku::Grid.new array: array
  end

  def valid?
    ALL_SETS.all? do |set|
      no_dups? set
    end
  end

  def valid_square? ord
    Sudoku::Grid.effected_sets(ord).all? do |set|
      no_dups? set
    end
  end

end
