class DDDBL_DB

  @dbConnection = nil
  @dbType = ''

  def initialize dbConfig

    raise ArgumentError, 'config has to be a hash' unless dbConfig.is_a? 'Hash'
    raise ArgumentError, 'no connection details given' unless dbConfig.member? 'connection'
    raise ArgumentError, 'no user given' unless dbConfig.member? 'user'
    raise ArgumentError, 'no password given' unless dbConfig.member? 'password'

    @dbConnection = DBI.connect dbConfig["connection"], dbConfig["user"], dbConfig['password']
    @dbType =  dbConfig['type'] unless dbConfig.member? 'type'

  end

end
