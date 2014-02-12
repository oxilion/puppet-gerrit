define gerrit::setting (
  $value,
  $ensure = present,
  $path   = "${::gerrit::gerrit_home}/${::gerrit::site_name}/etc/gerrit.config",
) {
  gerrit_config { $name:
    ensure => $ensure,
    path   => $path,
    value  => $value,
  }
}
