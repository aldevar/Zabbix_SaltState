{% if grains['os'] == 'CentOS' %}
{% if grains['osmajorrelease'] == '6' %}
manage_repo_2.4:
  file:
    - managed
    - name: /etc/yum.repos.d/zabbix.repo
    - source: salt://prod/zabbix/files/linux/zabbix/zabbix2.4.repo
{% endif %}

{% if grains['osmajorrelease'] == '7' %}
manage_repo_3.0:
  file:
    - managed
    - name: /etc/yum.repos.d/zabbix.repo
    - source: salt://prod/zabbix/files/linux/zabbix/zabbix3.0.repo
{% endif %}


manage_GPG:
  file:
    - managed
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
    - source: salt://prod/zabbix/files/linux/zabbix/RPM-GPG-KEY-ZABBIX

yum-check-update:
  cmd.run:
    - name: 'yum -y check-update'

zabbix_agent:
  pkg.installed:
    - name: zabbix-agent
    - skip_verify: true

manage_zabbix_conf:
  file:
    - managed
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://prod/zabbix/files/linux/zabbix/zabbix_agentd.conf

zabbix-agent:
  service.running:
    - enable: True
    - start: True

{% endif %}

{% if grains['os'] == 'Debian' %}
{% if grains['oscodename'] == 'wheezy' %}
manage_repo:
  file:
    - managed
    - name: '/tmp/zabbix-release_3.0-1+wheezy_all.deb'
    - source: salt://prod/zabbix/files/linux/zabbix/zabbix-release_3.0-1+wheezy_all.deb

manage_repo_proxy:
  file:
    - managed
    - name: /etc/apt/apt.conf.d/01proxy
    - source: salt://prod/zabbix/files/linux/zabbix/01proxy

install_package:
  cmd.run:
    - name: 'dpkg -i /tmp/zabbix-release_3.0-1+wheezy_all.deb'
    - require:
      - file: '/tmp/zabbix-release_3.0-1+wheezy_all.deb'

apt-get-update:
  cmd.run:
    - name: 'apt-get update'

zabbix_agent:
  pkg.installed:
    - name: zabbix-agent

manage_zabbix_conf:
  file:
    - managed
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://prod/zabbix/files/linux/zabbix/zabbix_agentd.conf


zabbix-agent:
  service.running:
    - name: zabbix-agent
    - restart: True
    - watch:
      - file: /etc/zabbix/zabbix_agentd.conf


{% endif %}
{% endif %}


{% if grains['os'] == 'Windows' %}
get_zabbix_agent:
  file:
    - recurse
    - name: C:\zabbix3
    - source: salt://prod/zabbix/files/windows/zabbix
    - include_empty: True

manage_zabbix_agent_config:
  file:
    - managed
    - name: C:\zabbix3\conf\zabbix_agentd.win.conf
    - source: salt://prod/zabbix/files/windows/zabbix/conf/zabbix_agentd.win.conf
    - template: jinja


install_zabbix_agent:
  cmd.run:
    - name: 'zabbix_agentd.exe --config C:\zabbix3\conf\zabbix_agentd.win.conf --install'
    {% if grains['cpuarch'] == 'AMD64' %}
    - cwd: C:\zabbix3\bin\win64\
    {% elif grains['cpuarch'] == 'x86' %}
    - cwd: C:\zabbix3\bin\win32\
    {% endif %}
    - unless: 'sc query "Zabbix Agent"'

firewall_zabbix_agent:
  cmd.run:
    - name: 'netsh advfirewall firewall add rule name="TCP_10050_Zabbix_Agent" dir=in action=allow protocol=TCP localport=10050 remoteip=YOUR_ZABBIX_SERVER_IP'
    - unless: 'netsh advfirewall firewall show rule name="TCP_10050_Zabbix_Agent"'

stop_zabbix_agent:
  cmd.run:
    - name: 'zabbix_agentd.exe --stop'
    {% if grains['cpuarch'] == 'AMD64' %}
    - cwd: C:\zabbix3\bin\win64\
    {% elif grains['cpuarch'] == 'x86' %}
    - cwd: C:\zabbix3\bin\win32\
    {% endif %}
    - unless: 'sc query "Zabbix Agent" | find /i "STOPPED"'

start_zabbix_agent:
  cmd.run:
    - name: 'zabbix_agentd.exe --start'
    {% if grains['cpuarch'] == 'AMD64' %}
    - cwd: C:\zabbix3\bin\win64\
    {% elif grains['cpuarch'] == 'x86' %}
    - cwd: C:\zabbix3\bin\win32\
    {% endif %}
    - unless: 'sc query "Zabbix Agent" | find /i "RUNNING"'

{% endif %}
