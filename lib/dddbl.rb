require 'dddbl/helpers/php_parse_ini.func'

require "dddbl/dddbl_config"
require "dddbl/dddbl_query_pool"
require "dddbl/dddbl_query"
require "dddbl/dddbl_db_pool"
require "dddbl/dddbl_db"

require "dddbl/handler/execute"

require "dbi"

#dbh = DBI.connect('dbi:Pg:dddbl:localhost', 'postgres')

class DDDBL
  
  @dbAlias = ''
  @dbConnection = nil

  def initialize dbAlias

    @dbAlias = dbAlias
    @dbConnection = getDb

  end

  def get query_alias, *params

    dbQuery = DDDBL_Query_Pool.get(@dbConnection, query_alias)
    dbQuery.get params

  end

  private 

  def getDb

    DDDBL_DB_Pool.get @dbAlias

  end

end
