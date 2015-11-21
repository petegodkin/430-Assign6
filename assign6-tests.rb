require_relative 'assignment6'
require 'test/unit'
extend Test::Unit::Assertions

# NumC
assert_equal 14, interp(NumC.new(14), []).number

#binopC
assert_equal 31, interp(BinopC.new(:+, NumC.new(15), NumC.new(16)), []).number
assert_equal -20, interp(BinopC.new(:*, NumC.new(5), NumC.new(-4)), []).number

#
