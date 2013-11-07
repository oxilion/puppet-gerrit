# Class: gerrit::params
class gerrit::params {
  # Version of gerrit
  $gerrit_version = $::operatingsystem ? {
    default => '2.5',
  }
  # Group which gerrit is in
  $gerrit_group = $::operatingsystem ? {
    default => 'gerrit',
  }
  # GroupId of gerrit group
  $gerrit_gid = $::operatingsystem ? {
    default => undef,
  }
  # Username, gerrit runs on
  $gerrit_user = $::operatingsystem ? {
    default => 'gerrit',
  }
  # Groups for the gerrit user
  $gerrit_groups = $::operatingsystem ? {
    default => undef,
  }
  # Home-Directory where gerrit whould be installed
  $gerrit_home = $::operatingsystem ? {
    default => '/opt/gerrit',
  }
  # UserID of created gerrit User
  $gerrit_uid = $::operatingsystem ? {
    default => undef,
  }
  # Name of gerrit review site directory
  $gerrit_site_name = $::operatingsystem ? {
    default => 'review_site',
  }
  # type of Database storing configs of gerrit ['mysql' / 'postgresql' / 'h2']
  $database_type = $::operatingsystem ? {
    default => 'postgresql',
  }
  # Manage the database?
  $database_manage = $::operatingsystem ? {
    default => true,
  }
  # Default database password
  $database_password = $::operatingsystem ? {
    default => '',
  }
  $database_hostname = $::operatingsystem ? {
    default => 'localhost',
  }

  $database_database = $::operatingsystem ? {
    default => 'reviewdb',
  }

  $database_username = $::operatingsystem ? {
    default => 'gerrit',
  }

  # Package to install for providing JAVA
  $gerrit_java = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'openjdk-6-jdk',
    default                   => 'java-1.6.0-openjdk',
  }

  $canonical_web_url = "http://${::fqdn}/"
  $httpd_listen_url = 'http://*:8080/'

  $sshd_listen_address = '*:29418'

  $auth_type = 'HTTP'

  $download_mirror = 'http://gerrit-releases.storage.googleapis.com'
}
