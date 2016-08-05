manage_perf_script:
  file:
    - recurse
    - name: C:\scripts
    - source: salt://prod/zabbix/files/windows/zabbix/scripts/
    - include_empty: True

