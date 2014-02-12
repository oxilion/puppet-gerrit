class gerrit::settings (
  $canonical_web_url   = $::gerrit::canonical_web_url,
  $sshd_listen_address = $::gerrit::sshd_listen_address,
  $httpd_listen_url    = $::gerrit::httpd_listen_url,
  $database_type       = $::gerrit::database_type,
  $database_manage     = $::gerrit::database_manage,
  $database_hostname   = $::gerrit::database_hostname,
  $database_database   = $::gerrit::database_database,
  $database_username   = $::gerrit::database_username,
  $database_password   = $::gerrit::database_password,
  $auth_type           = $::gerrit::auth_type,
  $ldap_server         = $::gerrit::ldap_server,
  $ldap_username       = $::gerrit::ldap_username,
  $ldap_password       = $::gerrit::ldap_password,
  $ldap_account_base   = $::gerrit::ldap_account_base,
  $ldap_group_base     = $::gerrit::ldap_group_base,
  $user                = $::gerrit::gerrit_user,
  $java_home           = '/etc/alternatives/jre',
  $base_path           = 'git',
  $cache_directory     = 'cache',
  $smtp_server         = 'localhost',
) {
  # [gerrit]
  gerrit::setting {'gerrit/basePath':
    value => $base_path,
  }

  gerrit::setting {'gerrit/canonicalWebUrl':
    value => $canonical_web_url,
  }

  # [sendemail]
  gerrit::setting {'sendemail/smtpServer':
    value => $smtp_server,
  }

  # [container]
  gerrit::setting {'container/user':
    value => $user,
  }

  gerrit::setting {'container/javaHome':
    value => $java_home,
  }

  # [database]
  gerrit::setting {'database/type':
    value => $database_type,
  }

  gerrit::setting {'database/hostname':
    value => $database_hostname,
  }

  gerrit::setting {'database/database':
    value => $database_database,
  }

  gerrit::setting {'database/username':
    value => $database_username,
  }

  gerrit::setting {'database/password':
    value => $database_password,
  }

  # [sshd]
  gerrit::setting {'sshd/listenAddress':
    value => $sshd_listen_address,
  }

  # [httpd]
  gerrit::setting {'httpd/listenUrl':
    value => $httpd_listen_url,
  }

  # [cache]
  gerrit::setting {'cache/directory':
    value => $cache_directory,
  }

  # [auth]
  gerrit::setting {'auth/type':
    value => $auth_type,
  }

  # [ldap]
  $use_ldap = $auth_type ? {
    /(LDAP|HTTP_LDAP|CLIENT_SSL_CERT_LDAP)/ => present,
    default                                 => absent,
  }

  gerrit::setting {'ldap/server':
    ensure => $use_ldap,
    value  => $ldap_server,
  }

  gerrit::setting {'ldap/username':
    ensure => $use_ldap,
    value  => $ldap_username,
  }

  gerrit::setting {'ldap/password':
    ensure => $use_ldap,
    value  => $ldap_password,
  }

  gerrit::setting {'ldap/accountBase':
    ensure => $use_ldap,
    value  => $ldap_account_base,
  }

  gerrit::setting {'ldap/groupBase':
    ensure => $use_ldap,
    value  => $ldap_group_base,
  }
}
