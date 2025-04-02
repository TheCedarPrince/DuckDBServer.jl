"""
    execute(host, body; format = "JSONCompact") -> DataFrame

Sends an HTTP POST request to the specified `host` with the given `body` and parses the response into a `DataFrame`.

# Arguments

- `host::String` - The `httpserver` endpoint. 

- `body::String` - The query to execute against the DuckDB database.

- `format::String` : The response format, passed as a query parameter (default = `"JSONCompact"`).

# Returns

- A `DataFrame` returning the query results

# Example

```julia-repl
julia> execute("http://10.0.0.121:8080/", "SELECT person_id, year_of_birth FROM dbt_synthea_dev.person LIMIT 3;")
3×2 DataFrame
 Row │ person_id  year_of_birth 
     │ Int64      Int64         
─────┼──────────────────────────
   1 │         1           1955
   2 │         2           1940
   3 │         3           1986
```

"""
function execute(host::String, body::String; format::String = "JSONCompact")
    resp = HTTP.post(host;
       body,
       query = ["default_format" => format]
    );
    return convert(DataFrame, resp)
end

export execute
