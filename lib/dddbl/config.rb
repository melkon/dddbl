module DDDBL::Config

  class << self

    module DDDBL::Config::Defaults

      def default_query(query_alias)
        {
          :alias   => query_alias,
          :type    => DDDBL::GLOBAL_DB_DRIVER,
          :handler => ''
        }
      end

      def default_db(db_alias)
        {
          :pool_name => db_alias,
          :default   => false,
          :pass      => ''
        }
      end
      
    end

    include DDDBL::Config::Defaults
    
  end
  
  def self.parse_queries(file)
    raise StandardError, "#{file} does not exist" if !File.exists?(file)

    queries = {}

    IniFile.load(file).each do |query_alias, query_param, query_value|
      queries[query_alias] ||= default_query(query_alias)
      queries[query_alias][query_param.downcase.to_sym] = query_value
    end
    
    queries

  end

  def self.parse_dbs(file)
    raise StandardError, "#{file} does not exist" if !File.exists?(file)

    dbs = {}

    IniFile.load(file).each do |db_alias, db_param, db_value|
      dbs[db_alias] ||= default_db(db_alias)
      dbs[db_alias][db_param.downcase.to_sym] = db_value
    end

    dbs

  end

end