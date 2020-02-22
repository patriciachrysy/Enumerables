module Enumerable
  # 1. Create my_each
  def my_each
    (0..length - 1).each do |i|
      yield self[i]
    end
  end

  # 2. Create my_each_with_index
  def my_each_with_index
    (0..length - 1).each do |i|
      yield(self[i], i)
    end
  end

  # 3. Create my_select
  def my_select
    arr = []
    (0..length - 1).each do |i|
      criteria = yield(self[i])
      arr << self[i] if criteria
    end
    arr
  end

  # 4. Create my_all?
  def my_all?
    arr = []
    my_each do |i|
      condition = yield(i)
      arr << (condition ? true : false)
    end
    arr.include?(false) ? false : true
  end

  # 5. Create my_any?
  def my_any?
    arr = []
    my_each do |i|
      condition = yield(i)
      arr << (condition ? true : false)
    end
    arr.include?(true)
  end

  # 6. Create my_none?
  def my_none?
    arr = []
    my_each do |i|
      condition = yield(i)
      arr << (condition ? true : false)
    end
    arr.include?(true) ? false : true
  end

  # 7. Create my_count
  def my_count
    counter = 0
    each do |i|
      condition = yield(i)
      counter += 1 if condition
    end
    counter
  end

  # 8. Create my_map
  #   def my_map
  #     arr = []
  #     each do |i|
  #       condition = yield(i)
  #       arr << condition
  #     end
  #     arr
  #   end

  # 9. Create my_inject
  def my_inject(param)
    ans = nil
    each do |i|
      ans = yield(param, i)
      param = ans
    end
    ans
  end

  # 11. my_map (proc only)
  #   def my_map(&my_proc)
  #     arr = []
  #     each do |i|
  #       condition = my_proc.call(i)
  #       arr << condition
  #     end
  #     arr
  #   end

  # 12. my_map with proc/block
  def my_map(&my_proc)
    arr = []
    if my_proc
      each do |i|
        condition = my_proc.call(i)
        arr << condition
      end
    end
    unless my_proc # use block if proc is not given
      each do |i|
        condition = yield(i)
        arr << condition
      end
    end
    arr
  end
end

# 10. Test my_inject with multiply_els method
def multiply_els(array)
  array.my_inject(1) { |a, b| a * b }
end
# p multiply_els([1,2,3,4,5])

#
# TESTING -------------------------------
#
# prepend the module to Array to test.
# class Array
#     prepend Enumerable
# end
#
# [1,2,3,4,5].my_each{|n| print n}
# [1,2,3,4,5].my_each_with_index{|a,b| puts"#{a} with index #{b}"}
# p [1,2,3,4,5].my_select {|n| n.even?}
# p [1,2,3,4,5].my_all? {|n| n<10}
# p [1,2,3,4,5].my_any? {|n| n<0}
# [1,2,3,4,5].my_none? {|n| n<2}
# [1,2,3,4,5].my_count {|n| n<3}
# [1,2,3,4,5].my_map {|n| n**2}
# p [1,2,3,4,5].my_inject(1) {|a,b| a*b }
# p [1,2,3,4,5].my_map(&:to_s)
# p [1,2,3,4,5].my_map {|n| n.to_s}
