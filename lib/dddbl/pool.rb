class DDDBL::Pool

  class << self

    include DDDBL::Utils

    def [](dbtype, query_alias)
      # try to get the query for the given database driver
      # if none is given, check if there's a global query defined
      if @pool.has_key?(dbtype) && @pool[dbtype].has_key?(query_alias)
        @pool[dbtype][query_alias]
      elsif @pool.has_key?(DDDBL::GLOBAL_DB_DRIVER) && @pool[DDDBL::GLOBAL_DB_DRIVER].has_key?(query_alias)
        @pool[DDDBL::GLOBAL_DB_DRIVER][query_alias]
      else
        raise StandardError, "#{query_alias} not a saved query alias"
      end
    end

    def []=(dbtype, query_alias, query_config)
      raise StandardError, 'query is not properly configured' if !valid?(query_config)

      @pool ||= Hash.new(&(p=lambda{|h,k| h[k] = Hash.new(&p)}))
      @pool[dbtype][query_alias] = query_config
    end

    def <<(query_configs)
      query_configs.each do |key, query_config|
        DDDBL::Pool[query_config[:type], query_config[:alias]] = query_config
      end
    end

    private

    def mandatory
      [:alias, :query, :type]
    end

    def optional
      [:handler]
    end

  end

end

class DDDBL::Pool::DB

  class << self
    
    include DDDBL::Utils

    def <<(db_configs)
      db_configs.each do |key, db_config|
        raise StandardError, 'db_config is not valid' if !valid?(db_config)

        RDBI::connect_cached(db_config[:type], db_config);
        DDDBL::select_db(db_config[:pool_name]) if db_config[:default] && !DDDBL::connected?
      end
    end

    private

    def mandatory
      [:type, :pool_name, :host, :dbname, :user]
    end

    def optional
      [:default, :pass]
    end

  end

end