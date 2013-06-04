# = Class: gerrit
#
# This is the main gerrit class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*gerrit_version*]
#   Version of gerrit to install
#
# [*gerrit_group*]
#   Name of group gerrit runs under
#
# [*gerrit_gid*]
#   GroupId of gerrit_group
#
# [*gerrit_user*]
#   Name of user gerrit runs under
#
# [*gerrit_groups*]
#   Additional user groups
#
# [*gerrit_uid*]
#   UserId of gerrit_user
#
# [*gerrit_home*]
#   Home-Dir of gerrit user
#
# [*gerrit_site_name*]
#   Name of gerrit review site directory
#
# [*database_type*]
#   Database type
#
# [*database_manage*]
#   Whether to manage the database
#
# [*database_hostname*]
#   Database hostname
#
# [*database_database*]
#   Database name
#
# [*database_username*]
#   Database username
#
# [*database_password*]
#   Database password
#
# [*canonical_web_url*]
#   Canonical URL of the Gerrit review site, used on generated links
#
# [*sshd_listen_address*]
#   "<ip>:<port>" for the Gerrit SSH server to bind to
#
# [*httpd_listen_url*]
#   "<schema>://<ip>:<port>/<context>" for the Gerrit webapp to bind to
#
# == Author
#   Robert Einsle <robert@einsle.de>
#
class gerrit (
  $gerrit_version             = $gerrit::params::gerrit_version,
  $gerrit_group               = $gerrit::params::gerrit_group,
  $gerrit_gid                 = $gerrit::params::gerrit_gid,
  $gerrit_user                = $gerrit::params::gerrit_user,
  $gerrit_groups              = $gerrit::params::gerrit_groups,
  $gerrit_home                = $gerrit::params::gerrit_home,
  $gerrit_uid                 = $gerrit::params::gerrit_uid,
  $gerrit_site_name           = $gerrit::params::gerrit_site_name,
  $database_type              = $gerrit::params::database_type,
  $database_manage            = $gerrit::params::database_manage,
  $database_hostname          = $gerrit::params::database_hostname,
  $database_database          = $gerrit::params::database_database,
  $database_username          = $gerrit::params::database_username,
  $database_password          = $gerrit::params::database_password,
  $gerrit_java                = $gerrit::params::gerrit_java,
  $gerrit_email               = undef,
  $canonical_web_url          = $gerrit::params::canonical_web_url,
  $sshd_listen_address        = $gerrit::params::sshd_listen_address,
  $httpd_listen_url           = $gerrit::params::httpd_listen_url,
  $download_mirror            = 'http://gerrit.googlecode.com/files',
  $auth_type                  = $gerrit::params::auth_type,
  $ldap_server                = undef,
  $ldap_username              = undef,
  $ldap_password              = undef,
  $ldap_account_base          = undef,
  $ldap_account_pattern       = undef,
  $ldap_account_full_name     = undef,
  $ldap_account_email_address = undef,
  $ldap_group_base            = undef,
  $ldap_group_pattern         = undef,
  $ldap_group_member_pattern  = undef,
  $email_format               = undef,
) inherits gerrit::params {

  $gerrit_war_file = "${gerrit_home}/gerrit-${gerrit_version}.war"

  #LDAP
  $use_ldap = $auth_type ? {
    /(LDAP|HTTP_LDAP|CLIENT_SSL_CERT_LDAP)/ => true,
    default            => false,
  }

  # Install required packages
  package { [
  'wget', 'git'
  ]:
    ensure => installed;
  'gerrit_java':
    ensure => installed,
    name   => $gerrit_java,
  }

  # Crate Group for gerrit
  group { $gerrit_group:
    ensure     => present,
    gid        => $gerrit_gid,
  }

  # Create User for gerrit-home
  user { $gerrit_user:
    ensure     => present,
    comment    => 'User for gerrit instance',
    home       => $gerrit_home,
    shell      => '/bin/bash',
    uid        => $gerrit_uid,
    gid        => $gerrit_gid,
    groups     => $gerrit_groups,
    managehome => true,
    require    => Group[$gerrit_group]
  }

  # Correct gerrit_home uid & gid
  file { $gerrit_home:
    ensure     => directory,
    owner      => $gerrit_user,
    group      => $gerrit_group,
    require    => [
      User[$gerrit_user],
      Group[$gerrit_group],
    ]
  }

  if versioncmp($gerrit_version, '2.5') < 0 {
    $warfile = "gerrit-${gerrit_version}.war"
  } else {
    $warfile = "gerrit-full-${gerrit_version}.war"
  }

  # Funktion für Download eines Files per URL
  exec { 'download_gerrit':
    command => "wget -q '${download_mirror}/${warfile}' -O ${gerrit_war_file}",
    creates => $gerrit_war_file,
    require => [
    Package['wget'],
    User[$gerrit_user],
    File[$gerrit_home]
    ],
  }

  # Changes user / group of gerrit war
  file { 'gerrit_war':
    path    => $gerrit_war_file,
    owner   => $gerrit_user,
    group   => $gerrit_group,
    require => Exec['download_gerrit'],
  }

  # ´exec' doesn't work with additional groups, so we resort to sudo
  $command = "sudo -u ${gerrit_user} java -jar ${gerrit_war_file} init -d ${gerrit_home}/${gerrit_site_name} --batch --no-auto-start"

  if $database_manage {
    class {"gerrit::database::${database_type}":
      notify => Exec['init_gerrit'],
    }
  }

  # Initialisation of gerrit site
  exec {
    'init_gerrit':
      cwd       => $gerrit_home,
      command   => $command,
      creates   => "${gerrit_home}/${gerrit_site_name}/bin/gerrit.sh",
      logoutput => on_failure,
      require   => [
        Package[$gerrit_java],
        File['gerrit_war'],
        ],
  }

  # some init script would be nice
  file {'/etc/default/gerritcodereview':
    ensure  => present,
    content => "GERRIT_SITE=${gerrit_home}/${gerrit_site_name}\n",
    owner   => $gerrit_user,
    group   => $gerrit_group,
    mode    => '0444',
    require => Exec['init_gerrit']
  }->
  file {'/etc/init.d/gerrit':
    ensure  => link,
    target  => "${gerrit_home}/${gerrit_site_name}/bin/gerrit.sh",
    require => Exec['init_gerrit']
  }

  # Make sure the init script starts on boot.
  file { ['/etc/rc0.d/K10gerrit',
          '/etc/rc1.d/K10gerrit',
          '/etc/rc2.d/S90gerrit',
          '/etc/rc3.d/S90gerrit',
          '/etc/rc4.d/S90gerrit',
          '/etc/rc5.d/S90gerrit',
          '/etc/rc6.d/K10gerrit']:
    ensure  => link,
    target  => '/etc/init.d/gerrit',
    require => File['/etc/init.d/gerrit'],
  }

  # Manage Gerrit's configuration file (augeas would be more suitable).
  file { "${gerrit_home}/${gerrit_site_name}/etc/gerrit.config":
    content => template('gerrit/gerrit.config.erb'),
    owner   => $gerrit_user,
    group   => $gerrit_group,
    mode    => '0444',
    require => Exec['init_gerrit'],
    notify  => Service['gerrit']
  }

  service { 'gerrit':
    ensure    => running,
    hasstatus => false,
    pattern   => 'GerritCodeReview',
    require   => File['/etc/init.d/gerrit']
  }

}
