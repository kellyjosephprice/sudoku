require_relative '../sudoku'

class Sudoku::Generator
  attr_accessor :size, :givens, :grid

  def initialize options = {}
    defaults = {
      size: 9,
      givens: 11,
    }
    config = defaults.merge(options)

    @size = config[:size]
    @givens = config[:givens]
    @grid = config[:grid] || Sudoku::Grid.new(size: @size)

    seed
  end

  def seed
    grid.random_set(givens) do |n, ord|
      grid[[ord]] = n
    end
  end
end
