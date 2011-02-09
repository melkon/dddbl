# the php-library makes use of MULTI as result handler
# RDBI provides with Struct the same functionality
# for portability reasons of the query config files
# a MULTI handler is introduced which is an alias for Struct
class RDBI::Result::Driver::MULTI < RDBI::Result::Driver::Struct ; end