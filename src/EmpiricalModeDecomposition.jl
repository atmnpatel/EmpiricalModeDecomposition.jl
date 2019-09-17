module EmpiricalModeDecomposition

using AbstractFFTs
using Dierckx
using Distributions
using Distributed
using FFTW
using ForwardDiff
using LinearAlgebra
using Random
using Statistics

include("mode-decompositions/settings.jl")
include("mode-decompositions/emd.jl")
include("mode-decompositions/eemd.jl")
include("mode-decompositions/ceemdan.jl")
include("extras/hilbert.jl")

export EMDSetting, emd, EEMDSetting, eemd, CEEMDANSetting, ceemdan, hilbert_transform, hht

end # module
