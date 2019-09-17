"Stores settings for EMD convergence to IMF"
struct EMDConvergence
    "Number of siftings"
    num_siftings::Int64
    "S number"
    s_num::Int64

    function EMDConvergence(num_siftings::Int64, s_num::Int64) 
        if (s_num == 0 && num_siftings == 0) || (num_siftings < 0 || s_num < 0)
            throw(DomainError("Invalid EMD Settings."))
        end

        return new(num_siftings, s_num)
    end
end
 
