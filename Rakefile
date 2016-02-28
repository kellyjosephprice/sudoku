require 'benchmark'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'descriptive_statistics'

require_relative 'lib/udokus'

task default: %w[spec]

RSpec::Core::RakeTask.new(:spec)

def run_benchmark name, difficulty, count
  generator = Udokus::Generator.new difficulty: difficulty
  ratings = []

  Benchmark.bm(15) do |x|
    ratings = []

    x.report("#{name} (#{count}x):") do 
      count.times do 
        generator.fill.dig

        generator.solver.grid = generator.grid
        generator.solver.solve

        ratings << generator.rating
      end
    end
  end

  puts "mean rating: #{ratings.mean.round(2)} ± #{ratings.standard_deviation.round(2)}"
end

namespace :benchmark do
  desc "Run all the benchmarks"
  task default: %w[all]

  desc "Run all the benchmarks"
  task all: %w[boring easy medium hard insane]

  difficulties = {
    boring: {
      difficulty: 0,
      count: 1000
    },
    easy: {
      difficulty: 1,
      count: 1000
    },
    medium: {
      difficulty: 2,
      count: 500
    },
    hard: {
      difficulty: 3,
      count: 200
    },
    insane: {
      difficulty: 4,
      count: 100
    },
  }

  difficulties.each do |k, v|
    desc "Run the #{k} benchmarks"
    task k do 
      run_benchmark k, v[:difficulty], v[:count]
    end
  end
end

desc "Run the default benchmark"
task bm: "benchmark:default"
