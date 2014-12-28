require_relative '../sudoku'

class Sudoku::Grid
  attr_accessor :size, :givens, :array

  def initialize options = {}
    defaults = {
      size: 9,
      givens: 11,
    }
    config = defaults.merge(options)

    @size = config[:size]
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
    all_ords.select { |ord| self[ord].nil? }
  end

  def all_ords
    (0...size).map do |x|
      (0...size).map do |y|
        [x, y]
      end
    end.flatten(1)
  end

  def all_sets 
    cols = (0...size).to_a.map do |x|
      (0...size).to_a.map do |y|
        [x, y]
      end
    end

    rows = (0...size).to_a.map do |y|
      (0...size).to_a.map do |x|
        [x, y]
      end
    end

    small_grid = (0..2).to_a.map do |x|
      (0..2).to_a.map do |y|
        [x, y]
      end
    end.flatten(1)

    grids = small_grid.map do |x_offset, y_offset|
      small_grid.map do |x, y|
        [x + x_offset * 3, y + y_offset * 3]
      end
    end

    rows + cols + grids
  end

  def clear 
    Array.new(size) do
      Array.new(size)
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

  def fill
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
    ords = all_ords
    set = all_ords.sample(count)
    values = (1..(size * size)).to_a.map { |v| (v % size) + 1 }.sample(count)

    count.times do |n|
      block.call(values[n], set[n])
    end

    set.first(count)
  end

  def seed
    random_set(givens) do |n, ord|
      self[ord] = n
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
    all_sets.all? do |set|
      no_dups? set
    end
  end
end
