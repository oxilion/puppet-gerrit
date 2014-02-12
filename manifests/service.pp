class gerrit::service {
  service { 'gerrit':
    ensure    => running,
    enable    => true,
    hasstatus => false,
    pattern   => 'GerritCodeReview',
  }
}
