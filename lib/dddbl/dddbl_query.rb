class DDDBL_Query

  @dbConnection
  @queryDefinition

  def initialize dbConnection, queryDefinition

    raise ArgumentError, 'dbConnection is not a DDDBL_DB' unless dbConnection.is_a? DDDBL_DB
    raise ArgumentError, 'queryDefinition does not contain a query' unless queryDefinition.member? 'query'

    @dbConnection = dbConnection
    @queryDefinition = queryDefinition

    @queryHandler = parse_handler_config((@queryDefinition.member? 'handler') ? @queryDefinition['handler'] : 'execute')

  end

  def get queryParams

    send @queryHandler.shift, self, queryParams, @queryHandler

  end

  def executeQuery queryParams

    dbh = @dbConnection.dbConnection
    val = Array.new
    dbh.execute(@queryDefinition['query']) do |stmt|

      stmt.fetch_array do |row|

        val << row.to_a

      end

    end

    val

  end

end