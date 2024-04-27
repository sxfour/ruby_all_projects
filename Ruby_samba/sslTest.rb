require 'openssl'

puts OpenSSL::Digest.digest("SHA256", "abc")