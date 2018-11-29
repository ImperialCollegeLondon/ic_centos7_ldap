class ldap7 {
  include epel
  # Create LDAP script on host
  file { '/root/ldap7.sh':
    mode   => '0750',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/ldap7/ldap7.sh',
    notify => Exec['setup LDAP'],
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
    content => 'This file is managed by Puppet. LDAP setup completed.',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }
  # Install requirements for LDAP 
  Package {ensure => 'installed',
    before => Exec['setup LDAP']
  }

  package { 'wget': }
  package { 'vim': }
  package { 'deltarpm': }
  package { 'git': }
  package { 'pam_mount': }
  package { 'man': }
  package { 'samba-client': }
  package { 'samba-common': }
  package { 'cifs-utils': }
  package { 'nfs-utils': }
  package { 'openldap-clients': }
  package { 'nss-pam-ldapd': }
  package { 'krb5-workstation': }
  package { 'pam_krb5': }
  package { 'net-tools': }
  package { 'authconfig': }
  package { 'krb5-libs': }
  package { 'oddjob-mkhomedir': }
  package { 'pam_ldap': }
  package { 'sssd': }
  package { 'oddjob': }

  service { 'nfs':
    ensure => 'running',
    enable => true,
    before => Exec['setup LDAP']
  }

  service { 'rpcbind':
    ensure => 'running',
    enable => true,
    before => Exec['setup LDAP']
  }
}


