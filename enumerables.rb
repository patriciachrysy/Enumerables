module Enumerable
    def my_each
        for i in 0..self.length-1
            yield self[i]
        end
    end

    def my_each_with_index
        for i in 0..self.length-1
            yield(self[i],i)
        end
    end

    def my_select 
        arr=[]
        for i in 0..self.length-1
            criteria = yield(self[i])
            arr << self[i] if criteria
        end
        arr
    end

    def my_all?
        arr = []
        self.my_each do |i|
            condition = yield(i)
            condition ? arr<<true : arr<<false
        end
        arr.include?(false) ? false : true
    end

    def my_any?
        arr = []
        self.my_each do |i|
            condition = yield(i)
            condition ? arr<<true : arr<<false
        end
        arr.include?(true)
    end

    def my_none?
        arr = []
        self.my_each do |i|
            condition = yield(i)
            condition ? arr<<true : arr<<false
        end
        arr.include?(true) ? false : true
    end

    def my_count
        counter = 0
        self.each do |i|
            condition = yield(i)
            counter += 1 if condition
        end
        counter
    end

    def my_map
        arr = []
        self.each do |i|
            condition = yield(i)
            arr << condition
        end
        arr
    end

    def my_inject(param)
        ans = nil
        self.each do |i|
            ans = yield(param, i )
            param = ans
        end
        ans
    end

    def multiply_els
    end
=begin
    def my_map #proc only
    end

    def my_map #proc or block
    end
=end


end

class Array
    prepend Enumerable
end

# [1,2,3,4,5].my_each{|n| print n}
# [1,2,3,4,5].my_each_with_index{|a,b| puts"#{a} with index #{b}"}
# p [1,2,3,4,5].my_select {|n| n.even?}
# p [1,2,3,4,5].my_all? {|n| n<10}
# p [1,2,3,4,5].my_any? {|n| n<0}
# [1,2,3,4,5].my_none? {|n| n<2}
# [1,2,3,4,5].my_count {|n| n<3}
# [1,2,3,4,5].my_map {|n| n**2}
# p [1,2,3,4,5].my_inject(1) {|a,b| a*b }