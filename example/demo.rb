require 'rdbi'
require 'rdbi-driver-mysql'

require 'dddbl'

DDDBL::Pool::DB << DDDBL::Config.parse_dbs('file')
DDDBL::Pool     << DDDBL::Config.parse_queries('file')

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
