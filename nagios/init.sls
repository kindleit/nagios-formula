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

apache2:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/apache2/conf-enabled/nagios3.conf
