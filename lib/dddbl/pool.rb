#
# DDDBL - Definition Driven Database Layer
# Copyright (c) 2011 André Gawron. See LICENSE and README for details.
#
# DDDBL::Pool contains the parsed queries
#
class DDDBL::Pool

  class << self
    include DDDBL::Utils
  end

  mandatory [:alias, :query, :type]
  optional  [:handler]

  #
  # returns a stored query for given database driver
  # if none is found, the method looks in the global "namespace"
  # if there is also no query stored, it raises an exception.
  # 
  # @param [String] dbtype database's driver name (e.g. MySQL or PostgreSQL)
  # @param [String] query_alias the query's alias
  # 
  # @return [Hash] the query configuration
  # 
  # @raise [StandardError] if no query is stored under given alias and driver
  # 
  # @see [DDDBL::Pool::[]=] for hash keys
  # @see [DDDBL::GLOBAL_POOL] for global "namespace"
  #
  def self.[](dbtype, query_alias)
    if @pool.has_key?(dbtype) && @pool[dbtype].has_key?(query_alias)
      @pool[dbtype][query_alias]
    elsif @pool.has_key?(DDDBL::GLOBAL_POOL) && @pool[DDDBL::GLOBAL_POOL].has_key?(query_alias)
      @pool[DDDBL::GLOBAL_POOL][query_alias]
    else
      raise StandardError, "#{query_alias} not a saved query alias"
    end
  end

  #
  # sets a query configuration for given database pool
  # optional keys have to be set but can be empty.
  #
  # @param [String] dbtype database's driver name (e.g. MySQL or PostgreSQL)
  # @param [Hash] query_config a valid query configuration
  #
  # @raise [StandardError] if the query configuration is not valid
  #
  # @see #mandatory for mandatory query configration keys
  # @see #optional for optional query configuration keys
  #
  def self.[]=(dbtype, query_config)
    raise StandardError, 'query is not properly configured' if !valid?(query_config)

    @pool ||= Hash.new(&(p=lambda{|h,k| h[k] = Hash.new(&p)}))
    @pool[dbtype][query_config[:alias]] = query_config
  end

  #
  # shortcut for an array (or hash) of query configurations
  # adds the whole query_configs to their corresponding pools.
  #
  # @param [#each] query_configs a list of query_configs, has to respond to #each(key, query_config)
  #
  def self.<<(query_configs)
    query_configs.each do |key, query_config|
      DDDBL::Pool[query_config[:type]] = query_config
    end
  end

end

#
# DDDBL - Definition Driven Database Layer
# Copyright (c) 2011 André Gawron. See LICENSE and README for details.
# 
# DDDBL::Pool::DB contains the parsed database definitions
#
class DDDBL::Pool::DB

  class << self
    include DDDBL::Utils
  end

  mandatory [:type, :pool_name, :host, :dbname, :user]
  optional  [:default, :pass]
  
  #
  # adds the whole db_configs to the pool,
  # establishs a connection to each of them,
  # and selects the default database connection
  # if no connection is already set.
  #
  # @param [#each] query_configs a list of query_configs, has to respond to #each(key, query_config)
  #
  # @raise [StandardError] if the configration file is not valid
  #
  def self.<<(db_configs)
    db_configs.each do |key, db_config|
      raise StandardError, 'db_config is not valid' if !valid?(db_config)
      
      RDBI::connect_cached(db_config[:type], db_config);
      DDDBL::select_db(db_config[:pool_name]) if db_config[:default] && !DDDBL::connected?
    end
  end

end