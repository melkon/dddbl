class DDDBL_DB_Pool

  @@dbDefinitions = create_hash
  @@dbConnections = create_hash

  def self.addDefinition query

    p query

    @@dbDefinitions[query["alias"]] = query

  end

  def self.get dbAlias = ''

    raise ArgumentError, "dbalias has to be a string" unless dbAlias.respond_to? to_s

    @@dbConnections[dbAlias] = self.connect dbAlias unless @@dbConnections.member? dbAlias

  end

  def self.connect dbAlias

    if @@dbDefinitions.member? dbAlias then
      db = @@dbDefinitions[dbAlias]
    elsif dbAlias.empty?
      db = self.getDefault
    else
      raise StandardError, "cannot return database, neither default nor correct aliasdb is given"
    end

    db = DDDBL_DB.new @@dbDefinitions[dbAlias]
    @@dbConnections[dbAlias] = db

  end

end