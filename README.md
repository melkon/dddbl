= DDDBL - Definition Driven Database Layer

== What?

DDDBL is a library to simplify the use of (different) databases and splits up
application's and database's (e.g: SQL queries) code through an easy
and unified API. The SQL is defined in files outside of the application's source
to easiliy port the SQL to diffrent applications - or even programming languages.
Refering to the written queries using an alias makes it even more clearer and
better to understand for newcomers, who then don't have to waste time figuring out
what the query does.

== Why?

Many applications interacting with databases have the sql code directly written
in the its source. Reading, reviewing and understanding that
unfimiliar code can be hard, even more for non sql-pros. Most of the time -
to optimize the queries and the database performance in general - DBAs are hired
who are probably not familiar with the programming language used. So they have
to dig into the code and try to optimize it without breaking anything.

== Supported databases

Common RDMS like MySQL, PostgreSQL and SQLite are supported. The DDDBL uses another
gem called RDBI which simplifies the handling of several databases. For a full
list please of supported drivers please check the RDBI's github page
(https://github.com/RDBI/).

== It's a port, isn't it?

Yes. The DDDBL was orginally written in PHP and is a creation of Torsten Zühlsdorff.
For more information on the PHP version, go to http://www.dddbl.de (German only).
The ruby version will also be featured there in the near future.

=== Any differences?

Yes. As of writing, the ruby port does not include every functionality the
PHP version offers. For example:

* not as much freedom regarding manipulating query-parameter pre-execution besides
  casting the binded parameters to any value extendable through TypeLib
* caching of prepared statements

== Dependecies

The database handling and querying is handled by the RDBI library. For more
information please see their README (https://github.com/RDBI/rdbi/blob/master/README.txt)
or visit the project's page on https://github.com/RDBI/ .

== Getting started

=== Database definitions

Every database the DDDBL should connect to has to be defined in a configuration
file using the ini-format. Example:

    [TEST-DB]
    HOST = localhost
    DBNAME = test
    TYPE = PostgreSQL
    USER = root
    PASS =
    DEFAULT = true

* [TEST-DB]: alias of the database connection. It's used if the DDDBL shall
  execute the query to another database
* HOST: host of the database
* DBNAME: database to select
* TYPE: driver to use
* USER: user who will be used to connect to the database
* PASS: user's password
* DEFAULT: normally, the DDDBL needs to know which database shall be used
  to execute the query. If the DEFAULT flag is set to true, this connection
  will be used at first - no explit connection selection needed. DEFAULT is optional.

Now the file has to be added to the database pool:

    DDDBL::Pool::DB << DDDBL::Config.parse_dbs('/path/to/db/definitions.def')

The database has to be added before any queries. Adding a file with database
definitions results in establishing a connection to every defined database.

==== Selecting (another) database

If only one connection is used, the following is just "good-to-know".
To select (another) database but the default is done by calling

    DDDBL::select_db('TEST-DB')

Now every query executed after #select_db will be using the database connection
defined through the alias 'TEST-DB'.

=== Query definitions

The query definition file also uses the ini-format and has to be configurated
seperately from the application (that's what the DDDBL is all about, isn't it?)

As for now, the query definitions of the PHP and ruby versions are interchangable:

    [QUERY-ALIAS]
    QUERY = "SELECT * FROM table"
    HANDLER = MULTI

    [QUERY-MULTILINE]
    QUERY = "SELECT *
             FROM table
             WHERE foo = ?"
    HANDLER = MULTI

    [CREATE-TABLE]
    QUERY = "CREATE TABLE foobar ( id SERIAL, name VARCHAR(50) )"

* [QUERY-ALIAS]: as with the database definition, the alias is used to
  refer to the query inside of the application.
* QUERY: the sql query. It can be enclosed by " but it's optional as long
  as the query fits into one line. ? is used to define parameters which will
  be binded later on. No ; needed.
* HANDLER: the handler is in charge of transforming the query's result set.
  There's own section devoted to that topic. HANDLER is optional (since a
  result set can be empty).

As the database definitions, the query definitions also have to be added to the pool:

    DDDBL::Pool << DDDBL::Config.parse_queries('/path/to/query/definitions.sql')

==== Querying

To execute a query which was be added to the pool is straight forward:

    formated_result = DDDBL::get('QUERY-ALIAS')

    # binds 'bar'
    formated_result = DDDBL::get('QUERY-MULTILINE', 'bar')

    # without a result set
    DDDBL::get('CREATE-TABLE')

=== Transactions

DDDBL also supports transaction. More information on the implementation details
has to be looked up in the RDBI::Database documentation

    DDDBL::transaction do
        DDDBL::get('CREATE-TABLE')

        # will fail because QUERY-MULTILINE expects a parameter
        DDDBL::get('QUERY-MULTILINE')
    end

Since the QUERY-MULTLINE will fail, the whole transaction will be rolled back
and no table will be created.

=== Creating your own result handler

As you may know or guess by now, RDBI supports transforming the query's result
set to any datastructure you want. It's as straight forward as adding a query
file to the pool, just extend the RDBI's RDBI::Result::Driver class and
implement at least #fetch. The name of the new result driver is then the name
which has to be used in the query's HANDLER configuration field.

It's also possible to pass a configuration to the result driver defined in the
query definition:

    [QUERY-ALIAS]
    QUERY = "SELECT bar FROM foo;"
    HANDLER = MULTI INT::bar

MULTI, as in the other examples, is the name of the result driver. If there's
a whitespace following with more text, this additional text will be passed to
the result driver's constructor. The example definition will explitictly cast
every row's bar-column value to an Integer.

For more information on creating a result driver, please read the documentation
of RDBI::Result::Driver. If you want to overwrite a default result driver,
just override the class.

== Bughunting was successful!

Just report the bug through github's tracker: https://github.com/melkon/dddbl/issues

== I'd like to patch and / or help maintain DDDBL. How can I?

* Fork the project: http://github.com/melkon/dddbl
* Make your feature addition or bug fix.

== Copyright

Copyright (c) 2011 André Gawron. See LICENSE for details.