{% set nagios          = pillar.get('nagios', {}) %}
{% set installServer   = nagios.get('core.install'  , True ) %}
{% set installNRPE     = nagios.get('nrpe.install'  , False) %}
{% set installApache   = nagios.get('apache.install', False) %}
{% set configureApache = nagios.get('apache.config' , True ) %}


{% if installServer %}
nagios3:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/nagios3/commands.cfg
      - file: /etc/nagios3/cgi.cfg
      - file: /etc/nagios3/conf.d/*

nagios-bundle:
  pkg.installed:
    - pkgs:
      - nagios-plugins
      - nagios-plugins-standard
      - nagios3-cgi
      - nagios3-common
      - nagios3-core
      - nagios-nrpe-plugin
{% endif %}


{% if installNRPE %}
nagios-nrpe-server:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/nagios/nrpe.cfg
      - file: /etc/nagios/nrpe.d/*
    - require:
      - pkg: nagios-nrpe-server

nagios-nrpe-plugin:
  pkg:
    - installed
{% endif %}


{% if installApache %}
nagios_apache2:
  pkg:
    - name: apache2
    - installed
{% endif %}


{% if configureApache %}
nagios_apache2_service:
  service:
    - name: apache2
    - running
    - watch:
      - file: /etc/apache2/conf-enabled/nagios3.conf

/etc/apache2/conf-enabled/nagios3.conf:
  file.symlink:
    - target: /etc/nagios3/apache2.conf
{% endif %}


/etc/nagios3/commands.cfg:
  file.managed:
    - template: jinja
    - source: salt://nagios/templates/nagios_commands.jinja

/etc/nagios3/cgi.cfg:
  file.managed:
    - template: jinja
    - source: salt://nagios/templates/cgi.jinja


{% for minion, minioninfo in salt['mine.get']('*', 'network.interfaces').items() %}
nagios_minion_config_{{ minion }}:
  file.managed:
    - name: /etc/nagios3/conf.d/{{ minion }}.cfg
    - this_minion: {{ minion }}
    - this_ip: {{ minioninfo['eth0']['inet'][0]['address'] }}
    - template: jinja
    - source: salt://nagios/templates/nagios_minion.jinja
    - require:
      - pkg: nagios3
{% endfor %}


{% for user, info in pillar['nagios']['users'].items() %}
nagios_user_{{ user }}:
  module.run:
    - name: apache.useradd
    - pwfile: /etc/nagios3/htpasswd.users
    - user: {{ user }}
    - password: {{ pillar['nagios']['users'][user]['password'] }}
{% endfor %}
