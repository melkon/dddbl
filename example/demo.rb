require 'rdbi'
require 'rdbi-driver-postgresql'

require 'inifile'
require 'dddbl'

class RDBI::Result::Driver::YAL < RDBI::Result::Driver
  def initialize(result, *args)
    super
    RDBI::Util.optional_require('yaml')
  end

  def format_single_row(raw)
    ::Hash[column_names.zip(raw)].to_yaml
  end

  def format_multiple_rows(raw_rows)
    raw_rows.collect { |row| ::Hash[column_names.zip(row)] }.to_yaml
  end

  private
  def column_names
    @column_names ||= @result.schema.columns.map(&:name)
  end
end


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
