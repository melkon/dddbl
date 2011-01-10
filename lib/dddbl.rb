require 'php_parse_ini.func'

require "dddbl_config"
require "dddbl_query_pool"
require "dddbl_db_pool"

require "dbi"

#dbh = DBI.connect('dbi:Pg:dddbl:localhost', 'postgres')

class DDDBL

  def self.get query_alias, *params

    p query_alias
    p params

  end

  def getDb dbAlias = ''

    DDDBL_DB_Pool.get dbAlias

  end

end

DDDBL_Config.loadDbDefinitionsDir('.')
DDDBL_Config.loadQueriesDir('.')
