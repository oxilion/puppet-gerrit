# Class: gerrit::params
class gerrit::params {
  # Version of gerrit
  $gerrit_version = '2.8.1'

  # Group which gerrit is in
  $gerrit_group = 'gerrit'

  # GroupId of gerrit group
  $gerrit_gid = undef

  # Username, gerrit runs on
  $gerrit_user = 'gerrit'

  # Groups for the gerrit user
  $gerrit_groups = undef

  # Home-Directory where gerrit whould be installed
  $gerrit_home = '/opt/gerrit'

  # UserID of created gerrit User
  $gerrit_uid = undef

  # Name of gerrit review site directory
  $site_name = 'review_site'

  # type of Database storing configs of gerrit ['mysql' / 'postgresql' / 'h2']
  $database_type = 'postgresql'

  # Manage the database?
  $database_manage = true

  # Default database password
  $database_password = ''
  $database_hostname = 'localhost'
  $database_database = 'reviewdb'
  $database_username = 'gerrit'

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
