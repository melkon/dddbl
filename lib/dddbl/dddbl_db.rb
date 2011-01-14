class DDDBL_DB

  @dbConnection = nil
  @dbType = ''

  def initialize dbConfig

    raise ArgumentError, 'config has to be a hash' unless dbConfig.is_a? Hash
    raise ArgumentError, 'no connection details given' unless dbConfig.member? 'CONNECTION'
    raise ArgumentError, 'no user given' unless dbConfig.member? 'USER'
    raise ArgumentError, 'no password given' unless dbConfig.member? 'PASS'

    @dbConnection = DBI.connect dbConfig['CONNECTION'], dbConfig['USER'], dbConfig['PASS']
    @dbType =  dbConfig['TYPE'] if dbConfig.member? 'TYPE'

  end

end
