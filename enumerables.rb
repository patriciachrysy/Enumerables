module Enumerable
  # 1. Create my_each
  def my_each
    i = 0
    while i < length
      yield self[i] if block_given?
      i += 1
    end
    self unless block_given?
  end

  # 2. Create my_each_with_index
  def my_each_with_index
    i = 0
    while i < length
      yield(self[i], i) if block_given?
      i += 1
    end
    self unless block_given?
  end

  # 3. Create my_select
  def my_select
    arr = []
    (0..length - 1).each do |i|
      criteria = yield(self[i]) if block_given?
      arr << self[i] if criteria
    end
    block_given? ? arr : self
  end

  # 4. Create my_all?
  # helper method to check regex
  def check_my_all_regex(param)
    reg_array = []
    my_each { |i| reg_array << i.match?(param) }
    reg_array.include?(false) ? false : true
  end

  # helper method to check class
  def check_my_all_class(param)
    class_array = []
    my_each { |i| class_array.append(i.class == param) }
    class_array.include?(false) ? false : true
  end

  def my_all?(param = nil)
    arr_array = []
    # return check_my_all_regex(param) if param.class == Regexp

    return check_my_all_regex(param) if param.class == Regexp

    # return check_my_all_class(param) unless param.nil?
    return check_my_all_class(param) unless param.nil?

    # check yield and append it into an array
    my_each do |i|
      condition = yield(i) if block_given?
      arr_array << (condition ? true : false)
    end
    # return
    if block_given?
      arr_array.include?(false) ? false : true
    else
      false
    end
  end

  # 5. Create my_any?
  def my_any?
    arr = []
    my_each do |i|
      condition = yield(i) if block_given?
      arr << (condition ? true : false)
    end
    if block_given?
      arr.include?(true)
    else
      true
    end
  end

  # 6. Create my_none?
  def my_none?
    arr = []
    my_each do |i|
      condition = yield(i) if block_given?
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
    else
      each do |i|
        condition = yield(i) if block_given?
        arr << condition
      end
      block_given? ? arr : self
    end
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
class Array
  prepend Enumerable
end
#
# p [1,2,3,4,5].my_each
# [1,2,3,4,5].my_each_with_index{|a,b| puts"#{a} with index #{b}"}
# p [1,2,3,4,5].my_select
# p [1,2,3,4,5].my_all? {|n| n<10}
# p [1,2,3,4,5].my_any? {|n| n<0}
# [1,2,3,4,5].my_none? {|n| n<2}
# [1,2,3,4,5].my_count {|n| n<3}
# [1,2,3,4,5].my_map {|n| n**2}
# p [1,2,3,4,5].my_inject(1) {|a,b| a*b }
# p [1,2,3,4,5].my_map(&:to_s)
# p [1,2,3,4,5].my_map {|n| n.to_s}
# p [1,2,3,4,5].my_map
# p [1, 2, 3, 4, 5].my_all?(Integer)
# p [1, 2, 3, 4, 5].my_all?(Integer)
p %w[asdf asdf afgag asdfq asgas].my_all?(/a/)
# p [].class === Integer
# p 'asdf'.match?('b')
# p /123/.class

# p /a/.class == Regexp
