require "rdbi"

module DDDBL

  class << self
    
    @database = :default
    attr_accessor :database

    def get query_alias, *params
      sth = Query::Pool[RDBI::Pool[@database].get_dbh.driver][query_alias]
    end

  end

end

class DDDBL::Pool

  class << self

    def [](dbtype, query_alias)
      @pool[dbtype][query_alias]
    end

    def []=(dbtype, query_alias, query_config)
      @pool = Hash.new(&(p=lambda{|h,k| h[k] = Hash.new(&p)}))
      @pool[dbtype][query_alias] = query_config
    end

  end

end

# just a mock for now
module DDDBL::Config

  class << self

    def add_query file
      parse_query_config(file).each do |option,value|

      end
    end

    def add_db file
      parse_db_config(file).each do |option, value|

      end
    end

    private

    def parse file
      if :query == file
        return config = parse_query_config
      elsif :db == file
        return config = parse_db_config
      end
    end

    def parse_query_config
      {
        :alias   => "TEST-QUERY",
        :query   => "SHOW TABLES",
        :handler => "MULTI"
      }
    end

    def parse_db_config
      {
        :alias      => "TEST-DB",
        :connection => "DBI:Mysql:information_schema:localhost",
        :user       => "root",
        :pass       => "",
        :bind       => true,
        :default    => true,
      }
    end

  end

end



#DDDBL::get :query, 1,2,3,4

