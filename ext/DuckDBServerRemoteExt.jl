module DuckDBServerRemoteExt

    using DuckDBServer
    using LibSSH

    __init__() = println("Remote Extension was loaded!")

    """
    Remote

    """
    function DuckDBServer.start_server(remote_path, host; duckdb_host = "localhost", duckdb_port = 8080, port = 22, socket = nothing, user = nothing, log_verbosity = nothing, auto_connect = true, process_config = true, readonly = false, extension_downloaded = true)

        sesh = Session(
           host = host,
           port = port,
           socket = socket,
           user = user,
           log_verbosity = log_verbosity,
           auto_connect = auto_connect,
           process_config = process_config
        )

        duckdb_cmd =
        """
        LOAD httpserver;
        SELECT httpserve_start('$(duckdb_host)', '$(duckdb_port)', '');
        """

        extension_downloaded ? nothing : DuckDBServer._setup_extension(remote_path, sesh)

        if readonly == true
            run(`duckdb $(remote_path) -cmd "$(duckdb_cmd)" -readonly`, sesh)
        else
            run(`duckdb $(remote_path) -cmd "$(duckdb_cmd)"`, sesh)
        end

    end

    function DuckDBServer._setup_extension(path, sesh)
        run(`duckdb $path -c "INSTALL httpserver FROM community;"`, sesh)
    end

end
