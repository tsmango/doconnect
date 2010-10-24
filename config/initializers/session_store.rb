# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_doconnect_session',
  :secret      => 'bf45a5a391e4850d194e1cabba25f845fb33f1dede2ce3ab6ad73ea024d89caf07d1124fd371ebcedfb9101fff5b08dabe891eb94c03841c1404daf5a8ea07d1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
