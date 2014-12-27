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
    @array = clear
  end

  def [] ords
    @array[ords[0]][ords[1]]
  end

  def []= ords, value
    @array[ords[0]][ords[1]] = value
  end

  def all_ords
    (0...size).map do |x|
      (0...size).map do |y|
        [x, y]
      end
    end.flatten(1)
  end

  def clear
    Array.new(size) do
      Array.new(size)
    end
  end

  def fill
  end

  def random_set count, &block
    ords = all_ords
    set = all_ords.sample(count)

    count.times do |n|
      block.call(n, set[n])
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

  def valid?
  end
end
