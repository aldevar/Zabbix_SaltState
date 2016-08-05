# Zabbix_SaltState

Edit configuration file in files/linux/zabbix/conf/zabbix_agentd.conf and files/windows/zabbix/conf/zabbix_agentd.win.conf
Set configuration option
Server=Your_Zabbix_Server with your own zabbix server IP or server name
Do the same in init.sls at the end of line 122.

Run the state to deploy and configure zabbix-agent on Win32, Win64, Centos/RHEL 6, Centos/RHEL 7 or Debian Wheezy server
