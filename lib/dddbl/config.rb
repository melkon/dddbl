#
# DDDBL - Definition Driven Database Layer
# Copyright (c) 2011 André Gawron. See LICENSE and README for details.
#
# DDDBL::Config parses the configuration files for queries and databases.
#
# Feel free to implement another parser (for example YAML-based files)
# and overwrite or extend DDDBL::Config. DDDBL::Config::Defaults
# will give you reasonable default values.
#
# @example Parse database definitions
#   db_defintions = DDDBL::Config.parse_dbs('/path/to/file')
#
# @example Parse query definitions
#   query_definitions = DDDBL::Config.parse_queries('/path/to/file')
#
module DDDBL::Config

  class << self

    #
    # Offers methods to get default values for a database 
    # and query configuration.
    #
    module DDDBL::Config::Defaults

      #
      # returns the default values for a query configuration
      # 
      # @param [String] query_alias the query's alias
      # 
      # @return [Hash] the default values for a query configuration
      # @option [String] :alias will contain the query_alias
      # @option [String, Symbol] :type will contain DDDBL::GLOBAL_POOL
      # @option [String] :handler will contain an empty string
      #
      def default_query(query_alias)
        {
          :alias   => query_alias,
          :type    => DDDBL::GLOBAL_POOL,
          :handler => ''
        }
      end

      #
      # returns the default values for a database configuration
      # 
      # @param [String] db_alias the database's alias
      # 
      # @return [Hash] the default values for a database configuration
      # @option [String] :pool_name will contain the db_alias
      # @option [Boolean] :default will contain false
      # @option [String] :pass will contain the user's password
      #
      def default_db(db_alias)
        {
          :pool_name => db_alias,
          :default   => false,
          :pass      => ''
        }
      end
      
    end

    include DDDBL::Config::Defaults
    
  end
  
  #
  # parses the queries from given file
  #
  # @param [File] file containing query definitions in IniFile-format
  #
  # @return [Hash<Hash>] parsed queries
  #
  # @raise [ArgumentError] if file does not exist
  #
  # @see [IniFile] for more information on the syntax
  #
  def self.parse_queries(file)
    raise ArgumentError, "#{file} does not exist" if !File.exists?(file)

    queries = {}

    IniFile.load(file).each do |query_alias, query_param, query_value|
      queries[query_alias] ||= default_query(query_alias)
      queries[query_alias][query_param.downcase.to_sym] = query_value
    end
    
    queries

  end

  #
  # parses the databases from given file
  #
  # @param [File] file containing database definitions in IniFile-format
  #
  # @return [Hash<Hash>] parsed databases
  #
  # @raise [ArgumentError] if file does not exist
  #
  # @see [IniFile] for more information on the syntax
  #
  def self.parse_dbs(file)
    raise ArgumentError, "#{file} does not exist" if !File.exists?(file)

    dbs = {}

    IniFile.load(file).each do |db_alias, db_param, db_value|
      dbs[db_alias] ||= default_db(db_alias)
      dbs[db_alias][db_param.downcase.to_sym] = db_value
    end

    dbs

  end

end