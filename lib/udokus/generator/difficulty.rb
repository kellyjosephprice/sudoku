class Udokus::Generator
  module Difficulty
    DIFFICULTY = [
      {
        givens: 50,
        bounds: 5,
        search: 0,
        sequence: :random
      },
      {
        givens: 36,
        bounds: 4,
        search: 100,
        sequence: :random
      },
      {
        givens: 32,
        bounds: 3,
        search: 1000,
        sequence: :random
      },
      {
        givens: 28,
        bounds: 2,
        search: 10000,
        sequence: :random
      },
      {
        givens: 22,
        bounds: 0,
        search: 100000,
        sequence: :random
      }
    ]

    SEQUENCE = {
      random: Udokus::Grid::ALL_ORDS.shuffle,
      normal: Udokus::Grid::ALL_ORDS,
    }
  end
end
