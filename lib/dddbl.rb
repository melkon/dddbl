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

require 'dddbl/config'
require 'dddbl/pool'

# result handler
require 'dddbl/result/MULTI'