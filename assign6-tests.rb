require_relative 'assignment6'
require 'test/unit'
extend Test::Unit::Assertions

# NumC
assert_equal 14, interp(NumC.new(14), []).number

# BoolC
assert_equal false, interp(BoolC.new(false), []).boolean
assert_equal true, interp(BoolC.new(true), []).boolean

#BinopC
assert_equal 31, interp(BinopC.new(:+, NumC.new(15), NumC.new(16)), []).number
assert_equal -20, interp(BinopC.new(:*, NumC.new(5), NumC.new(-4)), []).number

#IfC
assert_equal 13, interp(IfC.new(BoolC.new(true), NumC.new(13), BoolC.new(false)), []).number
assert_equal false, interp(IfC.new(BoolC.new(false), NumC.new(13), BoolC.new(false)), []).boolean

#lamC
assert_equal [], interp(LamC.new([], NumC.new(5)), []).params

#idc
assert_equal 5, interp(IdC.new(:x), [Bind.new(:x, NumV.new(5))]).number

#appC
assert_equal 7, interp(AppC.new(LamC.new([:a, :b], BinopC.new(:+, IdC.new(:a), IdC.new(:b))), [NumC.new(3), NumC.new(4)]), []).number

#top eval tests
#assert_equal "28", topEval(['with', [:z, :=, 14], [:+ :z, :z]])
assert_equal "7", topEval([:with, [:f, "=", [:func, :a, :b, [:+, :a, :b]]], [:f, 3, 4]])
assert_equal "7", topEval([[:func, :a, :b, [:+, :a, :b]], 3, 4])
assert_equal "7", topEval([:+, 3, 4])
assert_equal "7", topEval(7)

#puts parse(['with', [:f, "=", [:func, :a, :b, [:+, :a, :b]]], [:f, 3, 4]]).args
