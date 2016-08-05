manage_zabbix-mysql_conf:
  file:
    - managed
    - name: /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf
    - source: salt://prod/zabbix/files/linux/mysql/userparameter_mysql_slavenode.conf

manage_my-cnf:
  file:
    - managed
    - name: /var/lib/zabbix/.my.cnf
    - source: salt://prod/zabbix/files/linux/mysql/my.cnf

zabbix-agent:
  service.running:
    - name: zabbix-agent
    - restart: True
    - watch:
      - file: /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf
