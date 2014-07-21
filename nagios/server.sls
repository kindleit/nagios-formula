/etc/apache2/conf-enabled/nagios3.conf:
  file.symlink:
    - target: /etc/nagios3/apache2.conf

/etc/nagios3/commands.cfg:
  file.managed:
    - template: jinja
    - source: salt://nagios/templates/nagios_commands.jinja

/etc/nagios3/cgi.cfg:
  file.managed:
    - template: jinja
    - source: salt://nagios/templates/cgi.jinja

{% for minion, minioninfo in salt['mine.get']('*', 'network.interfaces').items() %}
minion_config_{{ minion }}:
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
{{ user }}:
  module.run:
    - name: apache.useradd
    - pwfile: /etc/nagios3/htpasswd.users
    - user: {{ user }}
    - password: {{ pillar['nagios']['users'][user]['password'] }}
{% endfor %}
