# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ExpenseCalculator_session',
  :secret      => '314a2e98beee5c7e0f24e5348f59a26b356ed5e15cdb166323de90f4ecf25964a169072cfb297d7cbc06d6c1e354dc30e6152414766d39c3043f5c4b968d4379'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
