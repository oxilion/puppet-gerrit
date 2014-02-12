class gerrit::install(
  $user            = $::gerrit::gerrit_user,
  $uid             = $::gerrit::gerrit_uid,
  $group           = $::gerrit::gerrit_group,
  $groups          = $::gerrit::gerrit_groups,
  $gid             = $::gerrit::gerrit_gid,
  $home            = $::gerrit::gerrit_home,
  $version         = $::gerrit::version,
  $download_mirror = $::gerrit::download_mirror,
  $war_file        = $::gerrit::gerrit_war_file,
  $java            = $::gerrit::gerrit_java,
) {
  # Install required packages
  package { ['wget', 'git']:
    ensure => installed,
  }

  package { 'gerrit_java':
    ensure => installed,
    name   => $java,
  }

  # Create group for gerrit
  group { $group:
    ensure => present,
    gid    => $gid,
  }

  # Create user for gerrit-home
  user { $user:
    ensure     => present,
    comment    => 'User for gerrit instance',
    home       => $home,
    shell      => '/bin/bash',
    uid        => $uid,
    gid        => $gid,
    groups     => $groups,
    managehome => true,
    require    => Group[$group]
  }

  # Correct home uid & gid
  file { $home:
    ensure     => directory,
    owner      => $user,
    group      => $group,
    require    => [User[$user], Group[$group]],
  }

  if versioncmp($version, '2.5') < 0 or versioncmp($version, '2.5.3') >= 0 {
    $remote_war_file = "gerrit-${version}.war"
  } else {
    $remote_war_file = "gerrit-full-${version}.war"
  }

  # Function to download gerrit releases
  exec { 'download_gerrit':
    command => "wget -q '${download_mirror}/${remote_war_file}' -O ${war_file}",
    creates => $war_file,
    require => [
      Package['wget'],
      User[$user],
      File[$home]
    ],
  }

  # Changes user / group of gerrit war
  file { 'gerrit_war':
    path    => $war_file,
    owner   => $user,
    group   => $group,
    require => Exec['download_gerrit'],
  }
}
