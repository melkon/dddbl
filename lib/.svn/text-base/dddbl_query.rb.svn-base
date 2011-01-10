class DDDBL_Query

  @dbConnection
  @queryDefinition

  def initialize dbConnection, queryDefinition

    raise ArgumentError, 'dbConnection is not a DDDBL_DB' unless dbConnection.is_a? DDDBL_DB
    raise ArgumentError, 'queryDefinition does not contain a query' unless queryDefinition.member? 'query'

    @dbConnection = dbConnection
    @queryDefinition = queryDefinition

  end

  def get

    queryHandler = @queryDefinition['handler'] || 'execute'
    


  end

end