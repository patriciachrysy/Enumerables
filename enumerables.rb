module Enumerable
  # 1. Create my_each
  def my_each
    if block_given?
      i = 0
      while i < size
        yield to_a[i] if block_given?
        i += 1
      end
    else
      to_enum(:my_each)
    end
  end

  # 2. Create my_each_with_index
  def my_each_with_index
    i = 0
    while i < length
      yield(self[i], i) if block_given?
      i += 1
    end
    return to_enum(:my_each_with_index) unless block_given?
  end

  # 3. Create my_select
  def my_select
    arr = []
    (0..length - 1).each do |i|
      criteria = yield(self[i]) if block_given?
      arr << self[i] if criteria
    end
    block_given? ? arr : to_enum(:my_select)
  end

  # 4. Create my_all?
  # Refactored my_all? & my_any? Helper method, to check Regex/Class/parameter passed in.
  # Disable rubocop to avoid high-complexity alerts on helper method
  # rubocop:disable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
  def my_all_any_none_helper(sub_param, value)
    # when main_param & block is not given.
    return value ? true : false if sub_param.nil? && !block_given? # true if element is true
    # when a Regex is passed as an argument
    return sub_param.match?(value) if sub_param.class == Regexp
    # when a class is passed as an argument
    return value.class == sub_param if sub_param.is_a?(Class)
    # when sub_param is given
    return sub_param == value unless sub_param.nil?

    yield(value) ? true : false
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
    !result # inverse of my_any?
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

  # 9. Create my_inject
  def my_inject(initial = nil, sym = nil)
    if block_given?
      if !initial.nil? # Check if arguments are passed in
        result = initial
        my_each { |element| result = yield(result, element) }
      else
        result = first # Result = first element if no argument
        to_a[1..-1].my_each { |element| result = yield(result, element) }
      end
    elsif !sym.nil? # if Symbol is given as 2nd parameter
      result = initial
      my_each { |element| result = result.send(sym, element) } # .send invoke method by Symbol
    elsif !initial.nil? # if initial is given only as a symbol
      result = first
      to_a[1..-1].my_each { |element| result = result.send(initial, element) }
    end
    result
  end

  # 12. my_map with proc/block
  def my_map(&my_proc)
    return to_enum(:my_map) unless my_proc || block_given?

    arr = []
    return to_enum(my_map) unless block_given?

    my_proc ? each { |i| arr << my_proc.call(i) } : each { |i| arr << yield(i) if block_given? }
    arr
  end
end

# 10. Test my_inject with multiply_els method
def multiply_els(array)
  array.my_inject(:*)
end
