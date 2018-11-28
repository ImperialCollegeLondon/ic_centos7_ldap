# Configure a CentOS 7 machine for College LDAP
[![Build Status](https://travis-ci.org/ImperialCollegeLondon/ic_centos7_ldap.svg?branch=master)](https://travis-ci.org/ImperialCollegeLondon/ic_centos7_ldap)

## Usage

Add class ldap7 to your control repo and this module will copy and execute (once!) an LDAP configuration script that will allow you to use College authentication.

I know that is very un-puppet to copy and run a script this way but the alternatives of managing authconfig or file resources for LDAP were also pretty bad. In the future hopefully we can eliminate this module. It's not ideotemptive but if it runs one more than once it will not be destructive. As configured it should only run once on your host unless you delete /root/.ldap7.configured.


