class DDDBL_Query_Pool

  @@queryDefinitions = create_hash
  @@queryObjects = create_hash

  def self.addQuery queryAlias, queryConfig, type = ''

    raise StandardError,"#{queryAlias} already defined" if @@queryDefinitions[type].member? queryAlias

    @@queryDefinitions[type][queryAlias] = queryConfig

  end

  def self.get dbConnection, queryAlias

    raise ArgumentError, 'dbConnection is not a DDDB_DB' unless dbConnection.is_a? 'DDDBL_DB'

    dbType = dbConnection.dbType

    if @@queryDefinitions[dbType][queryAlias].empty? then
      raise StandardError, '#{dbType} and #{queryAlias} does not own a query definition'
    end

    if @@queryObjects[dbType][queryAlias].empty?
      @@queryObjects[dbType][queryAlias] = DDDB_Query.new dbConnection, @@queryDefinitions[dbType][queryAlias]
    end

    @@queryObjects[dbType][queryAlias]

  end

end