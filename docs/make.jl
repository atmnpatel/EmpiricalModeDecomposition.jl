using Documenter
push!(LOAD_PATH,"../src/")
using EmpiricalModeDecomposition

makedocs(;
  sitename="EmpiricalModeDecomposition.jl",
  checkdocs=:exports,
  pages = Any[
    "Home" => "index.md",
    "Library" => [
      "Reference" => "reference.md",
      "Extras" => "extras.md",
      "Internals" => "internals.md"
    ],
    "Methods" => "methods.md"
  ]
)

deploydocs(
  repo = "github.com/atmnpatel/EmpiricalModeDecomposition.jl.git"
)
