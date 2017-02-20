Kemalyst::Handler::Session.config do |config|
  # The secret is used to avoid the session data being changed.  The session
  # data is stored in a cookie.  To avoid changes being made, a security token
  # is generated using this secret.  To generate a secret, you can use the
  # following command:
  # crystal eval "require \"secure_random\"; puts SecureRandom.hex(64)"
  #
  config.secret = "35667db69471d5321f0e203a063f53e5beb7c859a11691083d7d9b450636979f9effc6ddf368e8481f37f0ae34419c288e9eeb73eaabf8a66fa4b2284b144187"
end
