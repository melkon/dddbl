require 'rdbi'
require 'rdbi-driver-mysql'

require 'inifile'
require 'dddbl'

DDDBL::Pool::DB << DDDBL::Config.parse_dbs('dbdef.def')
DDDBL::Pool     << DDDBL::Config.parse_queries('test.sql')

DDDBL::get('TEST-QUERY')

DDDBL::get('TEST-INSERT', 'andre')
DDDBL::get('TEST-INSERT', 'melkon')

before = DDDBL::get('TEST-SELECT') ; p before

begin
  DDDBL::transaction do

    DDDBL::get('TEST-UPDATE', 'thorny', 2)

    # raises an exception
    # rollback initiated
    # throws an exception
    DDDBL::get('TEST-INSERT')

end ; rescue => e ; end

after =  DDDBL::get('TEST-SELECT') ; p after


if before.to_s == after.to_s
  p "transaction rollbacked"
else
  p "transaction commited"
end

DDDBL::get('TEST-DROP')
