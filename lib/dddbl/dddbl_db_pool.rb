class DDDBL_DB_Pool

  @@dbDefinitions = create_deep_hash
  @@dbConnections = create_deep_hash
  @@dbDefault     = ""

  def self.addDefinition dbAlias, dbDefinition

    if dbDefinition.has_key? "default" then
      @@dbDefault = dbAlias
    end

    @@dbDefinitions[dbAlias] = dbDefinition

  end

  def self.get dbAlias = ''

    raise ArgumentError, "dbalias has to be a string" unless dbAlias.respond_to? :to_s

    @@dbConnections[dbAlias] = self.connect dbAlias unless @@dbConnections.member? dbAlias

    @@dbConnections[dbAlias]

  end

  def self.connect dbAlias

    if @@dbDefinitions.member? dbAlias then
      dbConfig = @@dbDefinitions[dbAlias]
    elsif @@dbDefinition.member? @@dbDefault
      dbConfig = @@dbDefinition[@@dbDefault]
    else
      raise StandardError, "cannot return database, neither default nor correct aliasdb is given"
    end

    dbConnection = DDDBL_DB.new dbConfig
    @@dbConnections[dbAlias] = dbConnection

    dbConnection

  end

end