{% set installNRPE = pillar.get('nagios.nrpe.install', True) %}
{% set server = pillar.get('nagios.server', '127.0.0.1') %}
{% set allowed_hosts = pillar.get('nagios.nrpe.allowed_hosts', server) %}

/etc/nagios/nrpe.d/salt.cfg:
  file.managed:
    - name: /etc/nagios/nrpe.d/salt.cfg
    - template: jinja
    - source: salt://nagios/templates/nrpe_commands.jinja

nagios_nrpe_allowed_hosts:
  file.replace:
    - name: /etc/nagios/nrpe.cfg
    - pattern: allowed_hosts=127.0.0.1
    - repl: allowed_hosts={{ allowed_hosts }}
