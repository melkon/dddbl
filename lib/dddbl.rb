#
# DDDBL - Definition Driven Database Layer
# Copyright (c) 2011 André Gawron. See LICENSE and README for details.
#
# @example Executing Query
#   result = DDDBL::get('QUERY-ALIAS', 'foo', 'bar')
#
# @example Simple Transaction
#   DDDBL::transaction do
#     DDDBL::get('QUERY-ALIAS', 'foo', 'bar')
#     DDDBL::get('CREATE-TABLE')
#   end
#
# @example Select another database
#   DDDBL::select_db('DATABASE-ALIAS')
#
class DDDBL

  #
  # a query can be associated with a specific
  # database driver but if none is given, it will
  # be safed in GLOBAL_POOL so every database connection
  # can execute the defined query.
  #
  GLOBAL_POOL = :default
  
  class << self

    #
    # selects an database connection which will then 
    # be used to execute queries. if the connection 
    # is not yet established, it will be after calling 
    # this method.
    # 
    # @param [String] database_name databse alias which was defined in the config file
    #
    def select_db(database_name)
      if @dbh == nil || @database != database_name
        @dbh = RDBI::pool(database_name).get_dbh
      end
    end

    #
    # executes a defined alias and returns its result set which is
    # transformed by an optionally defined result hanlder before.
    #
    # #get uses the current database connection set by #select_db
    # if none was explicity selected but a default database was set
    # using the configuration files, the default connection
    # will be used.
    #
    # @param [String] query_alias querie's alias defined in the config file
    # @param [Array] *binds the parameters which shall be binded to the query
    #
    # @return the result set transformed by the defined handler
    #
    def get(query_alias, *binds)
      query = DDDBL::Pool[@dbh.driver, query_alias]
      res = @dbh.execute(query[:query], *binds)
      res.as(query[:handler]).fetch(:all) if !query[:handler].empty?
    end

    #
    # delegates method calls to RDBI::Database
    # DDDBL::transaction is currently implemented this way.
    # 
    # @param [String] method valid RDBI::Database method
    # @param [Array] *args RDBI::Database method's arguments
    # @param [Proc] &block and finally the optional block
    #
    # @return everything that the RDBI::Datbase method calls will return
    # @return [Boolean] false if no database connection is set
    #
    # @raise [ArgumentError] if RDBI::Database does not implement given method
    #
    def method_missing(method, *args, &block)
      return false if !@dbh.is_a? RDBI::Database
      raise ArgumentError, "RDBI::Database doesnt have #{method}" if !@dbh.respond_to?(method)

      @dbh.send(method, *args, &block)
    end

  end

end

#
# DDDBL::Utils provides methods for validation of queries
# and database definitions. 
# 
# @see DDDBL::Pool for implementation examples
# @see DDDBL::Pool::DB for implementation examples
#
module DDDBL::Utils

  #
  # sets the mandatory fiels of a configuration
  # 
  # @param [#each] fields which are mandatory, has to implement `#each`
  #
  # @raise [ArgumentError] if fields does not respond to #each
  #
  def mandatory(fields)
    raise ArgumentError, 'parameter has to implement #each' if !fields.respond_to?('each')
    
    @mandatory = fields
  end

  #
  # sets the optional fiels of a configuration
  #
  # @param [#each] fields which are optional, has to implement #each
  #
  # @raise [ArgumentError] if fields does not respond to #each
  #
  def optional(fields)
    raise ArgumentError, 'parameter has to implement #each' if !fields.respond_to?('each')

    @optional = fields
  end

  #
  # checks check for the defined mandatory and optional values
  # 
  # @param [#each] check data structure which implements #each
  # 
  # @return [Boolean] true if validation was successful
  # @return [Boolean] false if not
  #
  # @raise [ArgumentError] if check does not respond to #has_key?
  # @raise [ArgumentError] if check does not respond to #empty?
  #
  def valid?(check)
    raise ArgumentError, 'parameter has to implement has_key?' if !check.respond_to?('has_key?')
    raise ArgumentError, 'parameter has to implement empty?' if !check.respond_to?('empty?')
    
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