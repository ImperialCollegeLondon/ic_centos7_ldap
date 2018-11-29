#!/bin/env bash
echo "INFO: setup-authentication.sh: Switch over to LDAP and Kerberos 5"
ADSERVERS=icads34.ic.ac.uk:88,icads12.ic.ac.uk:88,icads13.ic.ac.uk:88,icads14.ic.ac.uk:88,icads36.ic.ac.uk:88,icads35.ic.ac.uk:88,icads15.ic.ac.uk:88
authconfig --useshadow --passalgo=sha512 --disablemd5 --disablefingerprint --enableldap --ldapserver unixldap.cc.ic.ac.uk --ldapbasedn ou=everyone,dc=ic,dc=ac,dc=uk --enablekrb5 --krb5realm IC.AC.UK --krb5kdc $ADSERVERS --krb5adminserver $ADSERVERS  --enablecache --enablemkhomedir --updateall

echo "INFO: setup-ssh.sh: Configuring sshd and ssh to only use Protocol v2"

MAC="$(/sbin/ifconfig ${KSDEVICE} | grep HWaddr | cut -dr -f3 | sed -e 's/ *//g')"
echo "INFO: read-hdb.sh: Getting system information from HDB for MAC address (${MAC})"
wget -N -q -O - http://hdb.ic.ac.uk/Zope/complete_reg/self_info?mac=${MAC} > /root/selfinfo

CUSTODIAN="$(cat /root/selfinfo | grep custodian | cut -d ';' -f 2)"
OWNER="$(cat /root/selfinfo | grep machineowner | cut -d ';' -f 2)"
SYSADMIN="$(cat /root/selfinfo | grep sysadmin | cut -d ';' -f 2)"

if [ "${CUSTODIAN}" = "" ]; then
  CUSTODIAN="${OWNER}"
fi

if [ "${SYSADMIN}" == "" ]; then
  SYSADMIN="${CUSTODIAN}"
fi

echo "INFO: setup-ssh.sh: Setting ssh banner"
echo > /etc/issue
echo "Unauthorised Access Is Prohibited" >> /etc/issue
echo >> /etc/issue
sed -i -e 's/#Banner.*/Banner \/etc\/issue/g' /etc/ssh/sshd_config

echo "INFO: setup-ssh.sh: Configuring sshd to allow owner, custodian and system administrator remote access (${OWNER},${CUSTODIAN},${SYSADMIN})"

/usr/sbin/usermod -a -G sshd root

for FIELD in "${OWNER}" "${CUSTODIAN}" "${SYSADMIN}"; do
        /usr/sbin/usermod -a -G sshd ${FIELD}
done

echo "AllowGroups sshd" >> /etc/ssh/sshd_config
