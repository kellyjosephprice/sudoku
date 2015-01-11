Sudoku
======

A sudoku generator.

Current Benchmarks
==================
% rake benchmark:all
                      user     system      total        real
boring (1000x):  44.410000   0.000000  44.410000 ( 44.399981)
average rating: 0.14
                      user     system      total        real
easy (1000x):    57.640000   0.000000  57.640000 ( 57.607509)
average rating: 0.64
                      user     system      total        real
medium (500x):   96.210000   0.010000  96.220000 ( 96.195151)
average rating: 1.63
                      user     system      total        real
hard (200x):    130.500000   0.010000 130.510000 (130.449767)
average rating: 2.65
                      user     system      total        real
insane (100x):  308.110000   0.000000 308.110000 (308.019246)
average rating: 5.64
