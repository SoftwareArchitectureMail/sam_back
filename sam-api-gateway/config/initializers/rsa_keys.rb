::RSAPublic = OpenSSL::PKey::RSA.new File.read 'rsa_keys/public.rsa.pub'
