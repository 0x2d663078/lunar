# audit_iptables
#
# Turn on iptables
#
# Refer to Section(s) 5.7-8   Page(s) 114-8  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 4.7-8   Page(s) 101-3  CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 4.7-8   Page(s) 92-3   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 3.6.1   Page(s) 153-4  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 3.6.1   Page(s) 139-40 CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 3.6.1-3 Page(s) 149-52 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_iptables () {
  if [ "$os_name" = "Linux" ]; then
    funct_linux_package install iptables
    for service_name in iptables ip6tables; do
      funct_systemctl_service enable $service_name
      funct_chkconfig_service $service_name 3 on
      funct_chkconfig_service $service_name 5 on
    done
    if [ "$audit_mode" != 2 ]; then
      check=`which iptables`
      if [ "$check" ]; then
        total=`expr $total + 1`
        check=`iptables -L INPUT -v -n |grep "127.0.0.0" |grep "0.0.0.0" |grep DROP`
        if [ ! "$check" ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   All other devices allow trafic to the loopback network [$insecure Warnings]"
        else
          secure=`expr $secure + 1`
          echo "Secure:    All other devices deny trafic to the loopback network [$secure Passes]"
        fi
      fi
    fi
  fi
}
