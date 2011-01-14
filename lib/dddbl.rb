require 'dddbl/helpers/php_parse_ini.func'

require "dddbl/dddbl_config"
require "dddbl/dddbl_query_pool"
require "dddbl/dddbl_db_pool"
require "dddbl/dddbl_db"

require "dbi"

#dbh = DBI.connect('dbi:Pg:dddbl:localhost', 'postgres')

class DDDBL

  def self.get query_alias, *params

    

  end

  def getDb dbAlias = ''

    DDDBL_DB_Pool.get dbAlias

  end

end
