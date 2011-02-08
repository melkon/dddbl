require 'rdbi'
require 'rdbi-driver-mysql'

require 'dddbl'

db = DDDBL::Config::Mock.get('TEST-DB')
db[:pool_name] = 'TEST-DB'

RDBI::connect_cached(db[:type], db);

DDDBL::select_db('TEST-DB')

DDDBL::Pool << DDDBL::Config::Mock.get('TEST-QUERY')
DDDBL::Pool << DDDBL::Config::Mock.get('TEST-UPDATE')
DDDBL::Pool << DDDBL::Config::Mock.get('TEST-SELECT')
DDDBL::Pool << DDDBL::Config::Mock.get('TEST-INSERT')
DDDBL::Pool << DDDBL::Config::Mock.get('TEST-DROP')

DDDBL::get('TEST-QUERY')

DDDBL::get('TEST-INSERT', 'andre')
DDDBL::get('TEST-INSERT', 'melkon')

p DDDBL::get('TEST-SELECT')

DDDBL::transaction do

  DDDBL::get('TEST-UPDATE', 'thorny', 2)
  DDDBL::get('TEST-INSERT')
  
end

p DDDBL::get('TEST-SELECT')

DDDBL::get('TEST-DROP')
