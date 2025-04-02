"""
    convert(::Type{DataFrame}, resp::HTTP.Messages.Response)

Converts an `HTTP.Messages.Response` from a DuckDB `httpserver` JSON response into a `DataFrame`.

# Arguments

- `resp::HTTP.Messages.Response` - The HTTP response from a DuckDB `httpserver`.

# Returns

- `DataFrame` - converted response
"""
function convert(::Type{DataFrame}, resp::HTTP.Messages.Response)
    data = String(resp.body) |> JSON3.read;
    df = DataFrame([t[:name] => DUCK_DICT[t[:type]][] for t in data.meta]);
    for d in data.data
        push!(df, d, cols = :setequal, promote = true)
    end
    return df
end
