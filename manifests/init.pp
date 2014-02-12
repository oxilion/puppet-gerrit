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
  $gerrit_version      = $gerrit::params::gerrit_version,
  $gerrit_group        = $gerrit::params::gerrit_group,
  $gerrit_gid          = $gerrit::params::gerrit_gid,
  $gerrit_user         = $gerrit::params::gerrit_user,
  $gerrit_groups       = $gerrit::params::gerrit_groups,
  $gerrit_home         = $gerrit::params::gerrit_home,
  $gerrit_uid          = $gerrit::params::gerrit_uid,
  $site_name           = $gerrit::params::site_name,
  $database_type       = $gerrit::params::database_type,
  $database_manage     = $gerrit::params::database_manage,
  $database_hostname   = $gerrit::params::database_hostname,
  $database_database   = $gerrit::params::database_database,
  $database_username   = $gerrit::params::database_username,
  $database_password   = $gerrit::params::database_password,
  $gerrit_java         = $gerrit::params::gerrit_java,
  $canonical_web_url   = $gerrit::params::canonical_web_url,
  $sshd_listen_address = $gerrit::params::sshd_listen_address,
  $httpd_listen_url    = $gerrit::params::httpd_listen_url,
  $download_mirror     = $gerrit::params::download_mirror,
  $auth_type           = $gerrit::params::auth_type,
  $ldap_server         = undef,
  $ldap_username       = undef,
  $ldap_password       = undef,
  $ldap_account_base   = undef,
  $ldap_group_base     = undef,
  $settings            = {},
) inherits gerrit::params {

  $gerrit_war_file = "${gerrit_home}/gerrit-${gerrit_version}.war"

  class {'::gerrit::install': } ~>
  class {'::gerrit::config': } ~>
  class {'::gerrit::service': } ->
  Class['gerrit']

  Gerrit_config <| |> ~> Class['gerrit::service']
}
