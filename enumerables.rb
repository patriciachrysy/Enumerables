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
        for i in 0..self.length-1
            yield
        end
    end


end

class Array
    prepend Enumerable
end

# [1,2,3,4,5].my_each{|n| print n}
[1,2,3,4,5].my_each_with_index{|a,b| puts"#{a} with index #{b}"}
