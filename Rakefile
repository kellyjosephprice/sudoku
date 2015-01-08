require 'rake/testtask'
require 'benchmark'
require_relative 'lib/sudoku/generator'

task default: %w[spec]

Rake::TestTask.new do |t|
  t.name = "spec"
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
end

task :benchmark do
  n = 5

  Benchmark.bm(12) do |x|
    x.report("level 2 (#{n}x):") do 
      generator = Sudoku::Generator.new difficulty: 1
      n.times { generator.fill.dig }
    end
  end
end
