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
  # Refactored my_all? & my_any? Helper method, to check Regex/Class/parameter passed in.
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
      condition = my_all_any_none_helper(main_param, element) { |i| block_given? ? yield(i) : i }
      result ||= condition
      break if result == true # once got a true, exit the loop
    end
    result
  end

  # 6. Create my_none?
  def my_none?(main_param = nil)
    result = false
    my_each do |element| # iterate over self
      condition = my_all_any_none_helper(main_param, element) { |i| block_given? ? yield(i) : i }
      result ||= condition
      break if result == true # once got a true, exit the loop
    end
    !result
  end

  # 7. Create my_count
  def my_count(param = nil)
    counter = 0
    return length if param.nil? && !block_given?

    my_each do |i|
      condition = yield(i) if block_given?
      counter += 1 if condition || param == i
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
  def my_inject(initial = nil, sym = nil)
    if block_given?
      if !initial.nil? # if initial is given
        result = initial
        my_each { |element| result = yield(result, element) }
      else # if block and param are not given
        result = self[0] # Result = first element
        self[1..-1].my_each { |element| result = yield(result, element) }
      end
    elsif !sym.nil? # if Symbol is given as 2nd parameter
      result = initial
      my_each { |element| result = result.send(sym, element) } # .send involve method by Symbol
    elsif !initial.nil? # if initial is given only as a symbol
      result = self[0]
      self[1..-1].my_each { |element| result = result.send(initial, element) }
    end
    result
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
    return self unless my_proc || block_given?

    arr = []
    my_proc ? each { |i| arr << my_proc.call(i) } : each { |i| arr << yield(i) if block_given? }
    arr
  end
end

# 10. Test my_inject with multiply_els method
def multiply_els(array)
  array.my_inject(:*)
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
# p [1, 2, 3, 4, 5].my_count { |n| n < 3 }
# p [1, 2, 3, 4, 5].my_map { |n| n**2 }
# p [1, 2, 3, 4, 5].my_inject(1) { |a, b| a * b }
# p [1, 2, 3, 4, 5].my_map(&:to_s)
# p [1, 2, 3, 4, 5].my_map { |n| n.to_s }
# p [1,2,3,4,5].my_map
# p [1, 2, 3, 4, 5].my_all?(Integer)
# p %w[asdf asdf afgag asdfq asgasg].none? {|i| i.length == 6}
# p [1,2,1,1,2].my_count {|x| x<2}
# p (5..10).inject { |sum, n|
#   sum + n
# }
# p (5..10).to_a.my_inject(1) { |product, n| product * n }
# longest = %w{ cat sheep bear }.my_inject { |memo, word| memo.length > word.length ? memo : word }
# p longest
# p (5..10).to_a.my_inject(:+)
# p (5..10).to_a.my_inject { |sum, n| sum + n }
# p (5..10).to_a.my_inject(1, :*)
# p (5..10).to_a.my_inject(1) { |product, n| product * n }
# longest = %w{ cat sheep bear }.my_inject do |memo, word|
#   memo.length > word.length ? memo : word
# end
# p longest
# p multiply_els([1,2,3,4,5])
