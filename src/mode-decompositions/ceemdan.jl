## Settings Struct

"Store the settings required for performing CEEMDAN."
struct CEEMDANSetting
    "EMD Setting"
    emd_setting::EMDSetting
    "Ensemble Size"
    ensemble_size::Int64
    "Seed"
    rng_seed::Int
    "SNRs for intermediate residues"
    snrs::Vector{Float64}

    function CEEMDANSetting(n::Int64, num_siftings::Int64, s_num::Int64, m::Int64,
                            ensemble_size::Int64, snrs::Vector{Float64}, rng_seed::Int=0) 
	    if ensemble_size < 1
            throw(DomainError("Invalid Ensemble Size for CEEMDAN"))
        elseif any(x->x < 0, snrs) 
            throw(DomainError("Invalid Noise Strength for EMD"))
	    elseif ensemble_size == 1 && any(x->x > 0, snrs)
            throw(DomainError("Noise Added to EMD"))
    	elseif ensemble_size > 1 && any(x->x == 0, snrs)
            throw(DomainError("No Noise Added to EEMD"))
        elseif size(snrs)[1] != ensemble_size
            throw(DomainError("Invalid set of SNRs"))
        end
        
        new(EMDSetting(n, num_siftings, s_num, m), ensemble_size, rng_seed, snrs)
    end
end


## Main Function

"""
    ceemdan(input::Vector{Float64}, s::CEEMDANSetting)

Return the IMFs computed by CEEMDAN given the settings.
"""
function ceemdan(input::Vector{Float64}, s::CEEMDANSetting)
    n = length(input)

    if (n == 0)
        throw(DomainError("Invalid size of input"))
    end

    output = zeros(n, s.emd_setting.m)
    res = zeros(n, s.emd_setting.m)
    rng = Normal(0.0, 1.0)

    res[:, 1] = @distributed (+) for i=s.ensemble_size
        local_mean(input + s.snrs[1]*emd_k(rand(n), s.emd_setting, 1), s.emd_setting)
    end

    res[:, 1] /= s.ensemble_size
    output[:,1] = input - res[:, 1]


    res[:, 2] = @distributed (+) for i=s.ensemble_size
        local_mean(res[:,1] + s.snrs[2]*emd_k(rand(n), s.emd_setting, 2), s.emd_setting)
    end

    res[:, 2] /= s.ensemble_size
    output[:,2] = res[:, 1] - res[:, 2]

    for k = 3:s.emd_setting.m
        res[:, k] = @distributed (+) for i=s.ensemble_size
            local_mean(res[:,k-1] + s.snrs[k]*emd_k(rand(n), s.emd_setting, k-1), s.emd_setting)
        end

        res[:, k] /= s.ensemble_size
        output[:,k] = res[:, k-1] - res[:, k]
    end

    return output
end

