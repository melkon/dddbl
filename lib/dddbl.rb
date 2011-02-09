class DDDBL

  GLOBAL_DB_DRIVER = ''
  
  class << self

    attr_reader :dbh
    alias connected? dbh

    attr_reader :database

    def select_db(database_name)
      if @dbh == nil || @database != database_name
        @dbh = RDBI::pool(database_name).get_dbh
      end
    end

    def get(query_alias, *params)
      query = DDDBL::Pool[@dbh.driver, query_alias]
      res = @dbh.execute(query[:query], *params)
      res.as(query[:handler]).fetch(:all) if query.has_key?(:handler)
    end

    def method_missing(method, *args, &block)
      @dbh.send(method, *args, &block)
    end

  end

end

class DDDBL::Pool

  class << self

    def [](dbtype, query_alias)

      # try to get the query for the given database driver
      # if none is given, check if there's a global query defined
      if @pool.has_key?(dbtype) && @pool[dbtype].has_key?(query_alias)
        @pool[dbtype][query_alias]
      elsif @pool.has_key?(DDDBL::GLOBAL_DB_DRIVER) && @pool[DDDBL::GLOBAL_DB_DRIVER].has_key?(query_alias)
        @pool[DDDBL::GLOBAL_DB_DRIVER][query_alias]
      end

    end

    def []=(dbtype, query_alias, query_config)
      @pool ||= Hash.new(&(p=lambda{|h,k| h[k] = Hash.new(&p)}))
      @pool[dbtype][query_alias] = query_config
    end

    def <<(query_configs)
      query_configs.each do |key, query_config|
        DDDBL::Pool[query_config[:type], query_config[:alias]] = query_config
      end
    end

  end

end

module DDDBL::Pool::DB

  def self.<<(db_configs)
    db_configs.each do |key, db_config|
      RDBI::connect_cached(db_config[:type], db_config);
      DDDBL::select_db(db_config[:pool_name]) if db_config[:default] && !DDDBL::connected?
    end
  end

end

module DDDBL::Config ; end

module DDDBL::Config::Mock

  def parse_dbs(file)
    {
      'TEST-DB' => { :type      => :MySQL,
                     :pool_name => 'TEST-DB',
                     :host      => 'localhost',
                     :dbname    => 'test',
                     :user      => 'root',
                     :pass      => '',
                     :default   => true },
      'TEST-ME' => { :type      => :MySQL,
                     :pool_name => 'TEST-ME',
                     :host      => 'localhost',
                     :dbname    => 'test_me',
                     :user      => 'root',
                     :pass      => '',
                     :default   => false }
    }
  end

  def parse_queries(file)
    {
      'TEST-QUERY'  => { :alias   => 'TEST-QUERY',
                         :query   => 'CREATE TABLE IF NOT EXISTS muff ( id SERIAL, name VARCHAR(255) )',
                         :type    => DDDBL::GLOBAL_DB_DRIVER },
      'TEST-DROP'   => { :alias   => 'TEST-DROP',
                         :query   => 'DROP TABLE IF EXISTS muff',
                         :type    => DDDBL::GLOBAL_DB_DRIVER },
      'TEST-UPDATE' => { :alias   => 'TEST-UPDATE',
                         :query   => 'UPDATE muff SET name = ? WHERE id = ?',
                         :type    => DDDBL::GLOBAL_DB_DRIVER },
      'TEST-INSERT' => { :alias   => 'TEST-INSERT',
                         :query   => 'INSERT INTO muff (name) VALUES (?)',
                         :type    => DDDBL::GLOBAL_DB_DRIVER },
      'TEST-SELECT' => { :alias   => 'TEST-SELECT',
                         :query   => 'SELECT * FROM muff',
                         :handler => 'Struct',
                         :type    => DDDBL::GLOBAL_DB_DRIVER },
    }
  end

end

class << DDDBL::Config
  include DDDBL::Config::Mock
end
