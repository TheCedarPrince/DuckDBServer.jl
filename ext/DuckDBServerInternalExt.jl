module DuckDBServerInternalExt

    using DuckDBServer
    using DuckDB

    __init__() = println("Internal Extension was loaded!")

    function DuckDBServer._setup_extension(con)
        DBInterface.execute(con, "INSTALL httpserver FROM community;")
    end

    """
    Internal
    """
    function DuckDBServer.start_server(path; host = "localhost", port = 8080, readonly = true, extension_downloaded = true)
        con = DBInterface.connect(DuckDB.DB, path)

        queries =
        """
        LOAD httpserver; 
        SELECT httpserve_start('$host', '$port', '');
        """
        
        extension_downloaded ? nothing : DuckDBServer._setup_extension(con)

        if readonly == true
            DuckDBServer._setup_extension(con)
            for query in split(queries, ";")[1:end-1]
                DBInterface.execute(con, query)
            end
        else
            for query in split(queries, ";")[1:end-1]
                DBInterface.execute(con, query)
            end
        end
         
    end

    """
    Internal
    """
    function DuckDBServer.stop_server(path; host = "localhost", port = 8080, readonly = true)
        con = DBInterface.connect(DuckDB.DB, path)

        queries =
        """
        LOAD httpserver; 
        SELECT httpserve_stop();
        """

        for query in split(queries, ";")[1:end-1]
            DBInterface.execute(con, query)
        end
    end
end
