# 8. Create my_map
#   def my_map
#     arr = []
#     each do |i|
#       condition = yield(i)
#       arr << condition
#     end
#     arr
#   end

# 11. my_map (proc only)
#   def my_map(&my_proc)
#     arr = []
#     each do |i|
#       condition = my_proc.call(i)
#       arr << condition
#     end
#     arr
#   end

# TESTING -------------------------------
#
# prepend the module to Array to test.
# class Array
#   prepend Enumerable
# end

# class Range
#   prepend Enumerable
# end
#
# p [1,2,3,4,5].each_with_index
# p [1,2,3,4,5].my_each
# p [1,2,3,4,5].my_map
# [1,2,3,4,5].my_each_with_index{|a,b| puts"#{a} with index #{b}"}
# p [1,2,3,4,5].my_select #error?
# p [1, 2, 3, 4, 5].my_all? { |n| n < 6 }
# p [2].my_all?(1)
# p [1, 2, 3, 4, 5].my_any? { |n| n < 1 }
# p [1,2,3,4,5].any?
# p [1,2,3,4,5].my_none? {|n| n<2}
# p [1, 2, 3, 4, 5].my_count { |n| n < 3 }
# p [1, 2, 3, 4, 5].my_map { |n| n**2 }
# p [1, 2, 3, 4, 5].my_inject(1) { |a, b| a * b }
# p [1, 2, 3, 4, 5].my_map(&:to_s)
# p [1, 2, 3, 4, 5].my_map { |n| n.to_s }
# p [1,2,3,4,5].my_map == [1,2,3,4,5].map #false?
# p [1, 2, 3, 4, '5'].my_any?(Integer)
# p %w[asdf asdf afgag asdfq asgasg].my_all?("a")
# p [1,2,1,1,2].my_count {|x| x<2}
# p [1,2,3,4,5].to_a
# p (5..10).my_inject(1) { |product, n| product * n }
# p (5..10).my_inject { |sum, n| sum + n } == (5..10).inject { |sum, n| sum + n }
# p (5..10).to_a.my_inject(1) { |product, n| product * n }
# longest = %w{ cat sheep bear }.my_inject { |memo, word| memo.length > word.length ? memo : word }
# p longest
# p (1..5).to_a[1..-1]
# p (5..10).to_a.my_inject(:+)
# p (5..10).to_a.my_inject { |sum, n| sum + n }
# p (5..10).to_a.my_inject(1, :*)
# p (5..10).to_a.my_inject(1) { |product, n| product * n }
# longest = %w{ cat sheep bear }.my_inject do |memo, word|
#   memo.length > word.length ? memo : word
# end
# p longest
# p multiply_els([1,2,3,4,5])
