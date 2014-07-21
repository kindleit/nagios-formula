/etc/nagios/nrpe.d/salt.cfg:
  file.managed:
    - name: /etc/nagios/nrpe.d/salt.cfg
    - template: jinja
    - source: salt://nagios/templates/nrpe_commands.jinja
allow_host:
  file.replace:
    - name: /etc/nagios/nrpe.cfg
    - pattern: allowed_hosts=127.0.0.1
    - repl: allowed_hosts={{ pillar['nagios']['server'] }}
