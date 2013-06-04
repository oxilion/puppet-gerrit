# puppet-gerrit
Puppet-Module for gerrit-Installation

## Example config

    class { 'gerrit':
      database_type     => 'postgresql',
      database_hostname => 'db01.example.com',
      database_database => 'gerrit_prod',
      database_username => 'gerrit',
      database_password => 'supersecret',
      httpd_listen_url  => 'proxy-http://127.0.0.1:8080/',
    }
