using Documenter
push!(LOAD_PATH,"../src/")
using EmpiricalModeDecomposition

makedocs(sitename="EmpiricalModeDecomposition.jl Documentation",
        pages = [
                 "Library" => [
                    "Reference" => "reference.md",
                    "Extras" => "extras.md",
                    "Internals" => "internals.md"
                    ],
                "Methods" => "methods.md"
              ]
       )
