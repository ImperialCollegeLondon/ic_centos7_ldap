class ldap7 {
  # Create LDAP script on host
  file { '/root/ldap7.sh':
    mode   => '0750',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/ic_centos7_ldap/ldap7.sh',
    notify => Exec['run_ldap_config'],
    before => Exec['setup LDAP']
  }
  # execute LDAP setup script
  exec { 'setup LDAP':
    command => '/root/ldap7.sh',
    creates => '/root/.ldap7.configured',
    timeout => 600,
    before  => File['/root/.ldap7.configured']
  }
  # Trap door to only allow LDAP setup once
  file { '/root/.ldap7.configured':
    ensure  => present,
    content => 'LDAP setup completed. Managed by Puppet',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }
}
