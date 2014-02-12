class gerrit::config(
  $home            = $::gerrit::gerrit_home,
  $user            = $::gerrit::gerrit_user,
  $group           = $::gerrit::gerrit_group,
  $site_name       = $::gerrit::site_name,
  $war_file        = $::gerrit::gerrit_war_file,
  $database_manage = $::gerrit::database_manage,
  $database_type   = $::gerrit::database_type,
  $settings        = $::gerrit::settings,
) {
  if $database_manage {
    class {"gerrit::database::${database_type}":
      notify => Exec['init_gerrit'],
    }
  }

  # 'exec' doesn't work with additional groups, so we resort to sudo
  $command = "sudo -u ${user} java -jar ${war_file} init -d ${home}/${site_name} --batch --no-auto-start"

  # Initialisation of gerrit site
  exec { 'init_gerrit':
    cwd       => $home,
    command   => $command,
    creates   => "${home}/${site_name}/bin/gerrit.sh",
    logoutput => on_failure,
  }

  # Configuration for the init script
  file {'/etc/default/gerritcodereview':
    ensure  => present,
    content => "GERRIT_SITE=${home}/${site_name}\n",
    owner   => $user,
    group   => $group,
    mode    => '0444',
  }

  # Symlink the init script
  file {'/etc/init.d/gerrit':
    ensure  => link,
    target  => "${home}/${site_name}/bin/gerrit.sh",
  }

  # Load all settings from parameters
  include ::gerrit::settings

  create_resources('gerrit::setting', $settings)
}
