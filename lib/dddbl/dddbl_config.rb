class DDDBL_Config

  def self.loadDbDefinitionsDir dir, pattern = '*def'

    raise ArgumentError, "dir does not exit" unless Dir.exists? dir

    (Dir.open dir).each do |file|
      self.loadDbDefinitions file if File.fnmatch?(pattern, file)
    end

  end

  def self.loadDbDefinitions file

    (php_parse_ini file).each do |dbAlias, dbConfig|
      DDDBL_DB_Pool.addDefinition(dbAlias, dbConfig)
    end

  end

  def self.loadQueriesDir dir, pattern = '*sql'

    raise ArgumentError, "dir does not exit" unless Dir.exists? dir

    (Dir.open dir).each do |file|
      self.loadQueries file if File.fnmatch?(pattern, file)
    end

  end

  def self.loadQueries file

    (php_parse_ini file).each do |queryAlias, config|
      DDDBL_Query_Pool.addQuery queryAlias, config
    end

  end

end
