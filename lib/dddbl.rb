class DDDBL

  GLOBAL_DB_DRIVER = :default
  
  class << self

    def select_db(database_name)
      if @dbh == nil || @database != database_name
        @dbh = RDBI::pool(database_name).get_dbh
      end
    end

    def get(query_alias, *params)
      query = DDDBL::Pool[@dbh.driver, query_alias]
      res = @dbh.execute(query[:query], *params)
      res.as(query[:handler]).fetch(:all) if !query[:handler].empty?
    end

    def method_missing(method, *args, &block)
      return false if !@dbh.is_a? RDBI::Database
      @dbh.send(method, *args, &block)
    end

  end

end

module DDDBL::Utils

  def mandatory(fields)
    @mandatory = fields
  end

  def optional(fields)
    @optional = fields
  end

  def valid?(check)
    @mandatory.each do |key|
      return false if !check.has_key?(key) || check[key].empty?
    end

    @optional.each do |key|
      return false if !check.has_key?(key)
    end
  end

end

require 'dddbl/config'
require 'dddbl/pool'

# result handler
require 'dddbl/results'