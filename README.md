Sudoku
======

A sudoku generator.

Current Benchmarks
==================

    % rake benchmark:all
                          user     system      total        real
    boring (1000x):  39.090000   0.000000  39.090000 ( 39.124782)
    average rating: 0.4
                          user     system      total        real
    easy (1000x):    48.010000   0.010000  48.020000 ( 48.072421)
    average rating: 1.58
                          user     system      total        real
    medium (500x):   49.330000   0.010000  49.340000 ( 49.375186)
    average rating: 2.57
                          user     system      total        real
    hard (200x):     55.390000   0.110000  55.500000 ( 55.564095)
    average rating: 3.26
                          user     system      total        real
    insane (100x):  103.950000   0.040000 103.990000 (104.145333)
    average rating: 6.07
