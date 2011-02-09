module DDDBL::Config 
  
  def self.parse_queries(file)

    raise StandardError, "#{file} does not exist" if !File.exists?(file)

    queries = {}

    IniFile.load(file).each do |query_alias, query_param, query_value|
      queries[query_alias] ||= default_query(query_alias)
      queries[query_alias][query_param.downcase.to_sym] = query_value
    end

    queries.select do |query_alias, query_config|
      validate_query(query_config)
    end

  end

  def self.parse_dbs(file)

    raise StandardError, "#{file} does not exist" if !File.exists?(file)

    dbs = {}

    IniFile.load(file).each do |db_alias, db_param, db_value|
      dbs[db_alias] ||= default_db(db_alias)
      dbs[db_alias][db_param.downcase.to_sym] = db_value
    end

    dbs.select do |db_alias, db_config|
      validate_db(db_config)
    end

  end
  
  private 

  def self.validate_query(query_config)

    mandatory_query.each do |key|
      return false if query_config[key].empty?
    end

    true

  end

  def self.validate_db(db_config)

    mandatory_db.each do |key|
      return false if db_config[key].empty?
    end

    true

  end

  def self.default_query(query_alias)
    {
      :alias   => query_alias,
      :type    => DDDBL::GLOBAL_DB_DRIVER,
      :handler => ''
    }
  end

  def self.default_db(db_alias)
    {
      :pool_name => db_alias,
      :default   => false,
      :pass      => ''
    }
  end

  def self.mandatory_query
    [:alias, :query, :type]
  end

  def self.mandatory_db
    [:type, :pool_name, :host, :dbname, :user]
  end

end