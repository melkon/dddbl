class DDDBL

  GLOBAL_DB_DRIVER = ''

  class << self

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

    def <<(query_config)
      DDDBL::Pool[query_config[:type], query_config[:alias]] = query_config
    end

  end

end

module DDDBL::Config

end

module  DDDBL::Config::Mock

  def self.get(query_alias)

    @mocks ||= {
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
      'TEST-DB'     => { :type    => :MySQL,
                         :host    => 'localhost',
                         :dbname  => 'test',
                         :user    => 'root',
                         :pass    => ''}
    }

    @mocks[query_alias]

  end

end
