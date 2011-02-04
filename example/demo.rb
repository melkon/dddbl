require "dddbl"

#DDDBL_Config.loadDbDefinitionsDir('.')
#DDDBL_Config.loadQueriesDir('.')


db = DDDBL.new 'TEST'

p db.get 'alias-test'


