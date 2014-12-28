require_relative '../sudoku'

class Sudoku::Grid
  attr_accessor :givens, :array

  ALL_ORDS = (0...9).map do |x|
    (0...9).map do |y|
      [x, y]
    end
  end.flatten(1)

  ALL_SETS = [
    [[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 8]],
    [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8]],
    [[2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5], [2, 6], [2, 7], [2, 8]],
    [[3, 0], [3, 1], [3, 2], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7], [3, 8]],
    [[4, 0], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [4, 7], [4, 8]],
    [[5, 0], [5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [5, 6], [5, 7], [5, 8]],
    [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7], [6, 8]],
    [[7, 0], [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7], [7, 8]],
    [[8, 0], [8, 1], [8, 2], [8, 3], [8, 4], [8, 5], [8, 6], [8, 7], [8, 8]],
    [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0], [8, 0]],
    [[0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [8, 1]],
    [[0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2], [8, 2]],
    [[0, 3], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3], [8, 3]],
    [[0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4], [8, 4]],
    [[0, 5], [1, 5], [2, 5], [3, 5], [4, 5], [5, 5], [6, 5], [7, 5], [8, 5]],
    [[0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6], [8, 6]],
    [[0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7], [8, 7]],
    [[0, 8], [1, 8], [2, 8], [3, 8], [4, 8], [5, 8], [6, 8], [7, 8], [8, 8]],
    [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]],
    [[0, 3], [0, 4], [0, 5], [1, 3], [1, 4], [1, 5], [2, 3], [2, 4], [2, 5]],
    [[0, 6], [0, 7], [0, 8], [1, 6], [1, 7], [1, 8], [2, 6], [2, 7], [2, 8]],
    [[3, 0], [3, 1], [3, 2], [4, 0], [4, 1], [4, 2], [5, 0], [5, 1], [5, 2]],
    [[3, 3], [3, 4], [3, 5], [4, 3], [4, 4], [4, 5], [5, 3], [5, 4], [5, 5]],
    [[3, 6], [3, 7], [3, 8], [4, 6], [4, 7], [4, 8], [5, 6], [5, 7], [5, 8]],
    [[6, 0], [6, 1], [6, 2], [7, 0], [7, 1], [7, 2], [8, 0], [8, 1], [8, 2]],
    [[6, 3], [6, 4], [6, 5], [7, 3], [7, 4], [7, 5], [8, 3], [8, 4], [8, 5]],
    [[6, 6], [6, 7], [6, 8], [7, 6], [7, 7], [7, 8], [8, 6], [8, 7], [8, 8]]
  ] 

  def initialize options = {}
    defaults = {
      givens: 11,
    }
    config = defaults.merge(options)

    @givens = config[:givens]
    @array = config[:array] || clear
  end

  def [] ords
    @array[ords[0]][ords[1]]
  end

  def []= ords, value
    @array[ords[0]][ords[1]] = value
  end

  def == other
    self.array == other.array
  end
  
  def all_empty 
    ALL_ORDS.select { |ord| self[ord].nil? }
  end

  def clear 
    self.array = Array.new(9) do
      Array.new(9)
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

  def complete?
    all_empty.empty?
  end

  def first_empty
    ALL_ORDS.find do |ord|
      self[ord].nil?
    end 
  end

  def no_dups? set
    count = Hash.new { 0 }

    set.reject do |ord|
      self[ord].nil?
    end.each do |ord|
      count[self[ord]] += 1
    end

    count.values.all? { |value| value <= 1 }
  end

  def random_set count, &block
    set = ALL_ORDS.sample(count)
    values = (1..81).to_a.map { |v| (v % 9) + 1 }.sample(count)

    count.times do |n|
      block.call(values[n], set[n])
    end

    set.first(count)
  end

  def seed
    random_set(givens) do |n, ord|
      self[ord] = n
    end
    unless valid?
      clear
      seed
    end
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

  def valid?
    ALL_SETS.all? do |set|
      no_dups? set
    end
  end
end
