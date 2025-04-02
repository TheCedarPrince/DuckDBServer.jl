using DuckDBServer
using Documenter

DocMeta.setdocmeta!(DuckDBServer, :DocTestSetup, :(using DuckDBServer); recursive=true)

makedocs(;
    modules=[DuckDBServer],
    authors="TheCedarPrince <jacobszelko@gmail.com> and contributors",
    sitename="DuckDBServer.jl",
    format=Documenter.HTML(;
        canonical="https://TheCedarPrince.github.io/DuckDBServer.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/TheCedarPrince/DuckDBServer.jl",
    devbranch="main",
)
