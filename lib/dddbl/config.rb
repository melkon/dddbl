module DDDBL::Config ; end

module DDDBL::Config::Mock

  def parse_dbs(file)
    {
      'TEST-DB' => { :type      => :MySQL,
                     :pool_name => 'TEST-DB',
                     :host      => 'localhost',
                     :dbname    => 'test',
                     :user      => 'root',
                     :pass      => '',
                     :default   => true },
      'TEST-ME' => { :type      => :MySQL,
                     :pool_name => 'TEST-ME',
                     :host      => 'localhost',
                     :dbname    => 'test_me',
                     :user      => 'root',
                     :pass      => '',
                     :default   => false }
    }
  end

  def parse_queries(file)
    {
      'TEST-QUERY'  => { :alias   => 'TEST-QUERY',
                         :query   => 'CREATE TABLE IF NOT EXISTS muff ( id SERIAL, name VARCHAR(255) )',
                         :type    => DDDBL::GLOBAL_DB_DRIVER },
      'TEST-DROP'   => { :alias   => 'TEST-DROP',
                         :query   => 'DROP TABLE IF EXISTS muff',
                         :type    => DDDBL::GLOBAL_DB_DRIVER },
      'TEST-UPDATE' => { :alias   => 'TEST-UPDATE',
                         :query   => 'UPDATE muff SET name = ? WHERE id = ?',
                         :type    => DDDBL::GLOBAL_DB_DRIVER },
      'TEST-INSERT' => { :alias   => 'TEST-INSERT',
                         :query   => 'INSERT INTO muff (name) VALUES (?)',
                         :type    => DDDBL::GLOBAL_DB_DRIVER },
      'TEST-SELECT' => { :alias   => 'TEST-SELECT',
                         :query   => 'SELECT * FROM muff',
                         :handler => 'MULTI',
                         :type    => DDDBL::GLOBAL_DB_DRIVER },
    }
  end

end