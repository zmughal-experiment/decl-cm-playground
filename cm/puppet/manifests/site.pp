class test {
  package { 'apache2':
    ensure => present,
  }
}

include test
