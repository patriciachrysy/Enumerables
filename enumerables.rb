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
  # Refactored my_all? & my_any? Helper method, to check Regex/Class/parameter passed in. (Enlightened by Mentor Rory Hellier)
  # Disable rubocop to avoid high-complexity alerts on helper methods
  # rubocop:disable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
  def my_all_any_none_helper(sub_param, value)
    if sub_param.nil? # when main_param is not given.
      return true if value # eg. [].my_all? == true (true when enumerator doesn't contain false/nil)
    elsif sub_param.class == Regexp # when a Regex is passed as an argument
      return true if sub_param.match(value)
    elsif sub_param.is_a?(Class) # when a class is passed as an argument
      return true if value.class == sub_param
    elsif sub_param == value # Check patterns other than Class/Regexp
      return true
    end
    return true if yield value == true

    false
  end
  # rubocop:enable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity

  # Refactoring my_all?, enlightened by mentor Rory Heiller

  def my_all?(main_param = nil)
    result = true
    my_each do |element| # iterate over self
      condition = my_all_any_none_helper(main_param, element) { |i| block_given? ? yield(i) : i } 
      result &&= condition # i equals each element here
      break if result == false # once find a false, exit the loop
    end
    result
  end

  # 5. Create my_any?
  def my_any?(main_param = nil)
    result = false
    my_each do |element| # iterate over self
      condition = my_all_any_none_helper(main_param, element) { |i| block_given? ? yield(i) : i } # i equals each element here
      result ||= condition 
      break if result == true #once got a true, exit the loop
    end
    result
  end

  # 6. Create my_none?
  def my_none?(main_param = nil)
    result = false
    my_each do |element| # iterate over self
      condition = my_all_any_none_helper(main_param, element) { |i| block_given? ? yield(i) : i } # i equals each element here
      result ||= condition 
      break if result == true #once got a true, exit the loop
    end
    !result
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
p %w[asdf asdf afgag asdfq asgasg].none? {|i| i.length == 7}
# p [].class === Integer
# p 'asdf'.match?('b')
# p /123/.class

# p /a/.class == Regexp
