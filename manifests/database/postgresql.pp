# Set up the database for postgresql
class gerrit::database::postgresql {

  # Prevents errors if run from /root etc.
  Postgresql_psql {
    cwd => '/',
  }

  include postgresql::client, postgresql::server
  postgresql::db { $gerrit::database_database:
    user     => $gerrit::database_username,
    password => postgresql_password($gerrit::database_username, $gerrit::database_password),
  }
}
