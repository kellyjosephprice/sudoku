class Udokus::Grid
  include Udokus::Grid::Sets

  attr_accessor :array, :cache

  def self.effected_row ord
    ROWS[ord[0]]
  end

  def self.effected_col ord
    COLS[ord[1]]
  end

  def self.effected_grid ord
    GRIDS[ord[0] / 3 * 3 + ord[1] / 3]
  end

  def self.from_flat_array array
    Udokus::Grid.new.tap do |grid|
      array.each do |ord, value|
        grid[ord] = value
      end
    end
  end

  def self.from_s string, delimeter = "\s"
    array = string.split("\n").map do |row|
      row.split(delimeter).map(&:to_i).map { |c| c <= 0 ? nil : c }
    end

    Udokus::Grid.new array: array
  end

  def initialize options = {}
    defaults = {
    }
    config = defaults.merge(options)

    @array = config[:array] || clear
  end

  def [] ord
    @array[ord[0]][ord[1]]
  end

  def []= ord, value
    @array[ord[0]][ord[1]] = value
  end

  def == other
    @array == other.array
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
    @array = Array.new(9) do
      Array.new(9)
    end
  end

  def complete?
    first_empty.nil?
  end

  def dup
    array_dup = array.map do |row|
      row.map do |value|
        value
      end
    end

    Udokus::Grid.new array: array_dup
  end

  def first_empty
    ALL_ORDS.find do |ord|
      @array[ord[0]][ord[1]].nil?
    end 
  end

  def minimum_remaining
    all_empty.max_by do |ord|
      Udokus::Grid::EFFECTED_ORDS[ord].select { |o| o }.count
    end
  end

  def no_dups? set
    set.reject do |ord|
      @array[ord[0]][ord[1]].nil?
    end.group_by do |ord| 
      @array[ord[0]][ord[1]] 
    end.select do |k, v| 
      v.size > 1 
    end.empty?
  end

  def shuffle!
    (2 + rand(3)).times do
      shuffle_rows!
      transpose!
    end

    (1 + rand(9)).times do 
      nums = (1..9).to_a.sample(2)
      swap_values! *nums
    end

    self
  end

  def shuffle_rows!
    grids = [ @array[0..2], @array[3..5], @array[6..8] ]
    @array = grids.shuffle!.flatten(1)
     
    [0, 3, 6].each do |offset|
      rows = (0..2).map { |y| @array[offset + y] }
      rows.shuffle!
      (0..2).each { |y| @array[offset + y] = rows[y] }
    end
  end

  def swap_values! one, two
    ALL_ORDS.each do |ord|
      if self[ord] == one
        self[ord] = two
      elsif self[ord] == two
        self[ord] = one
      end
    end
    self
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

  def to_string
    @array.flatten.map do |value|
      value.nil? ? " " : value
    end.join ""
  end

  def transpose!
    new_array = []

    9.times do |i|
      new_array[i] = Array.new(9)

      @array.each_with_index do |r,j|
        new_array[i][j] = r[i]
      end
    end

    @array = new_array
    self
  end

  def valid?
    ALL_SETS.all? do |set|
      no_dups? set
    end
  end

  def valid_square? ord
    Udokus::Grid::EFFECTED_SETS[ord].all? do |set|
      no_dups? set
    end
  end

  def valid_values ord
    return [] unless @array[ord[0]][ord[1]].nil?

    counts = Hash.new(0)

    Udokus::Grid::EFFECTED_ORDS[ord].each do |other|
      counts[@array[other[0]][other[1]]] += 1
    end

    (1..9).reject do |value|
      counts[value] > 0
    end
  end

end
