module Enumerable
    def my_each
        for i in 0..self.length
            yield self[i]
        end
    end

end

class Array
    prepend Enumerable
end

[1,2,3,4,5].my_each{|n| print n}

